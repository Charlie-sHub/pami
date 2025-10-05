// ProductionInterestedShoutOutsRepository – Hydration Strategy Notes
// ------------------------------------------------------------------
// Context
// - ShoutOut domain entity now includes: `creatorId` (persisted) and
//   `creatorUser: Option<User>` (transient, NOT persisted and NOT part of the DTO).
// - This repository is responsible for returning hydrated ShoutOuts for views
//   that require user info (e.g., InterestedShoutOutsTab), while keeping reads
//   quick and efficient on Firestore.
//
// Key Principles
// 1) Persist only ShoutOut data in Firestore (DTO excludes creatorUser).
// 2) Fetch ShoutOuts first, then batch-fetch Users by creatorId.
// 3) Hydrate by copying each ShoutOut with creatorUser: some(user) when found.
// 4) Keep the API streaming-friendly; avoid N+1 reads and excessive rebuilds.
// 5) Staleness of user profile during a session is acceptable for MVP.
// 6) Dismissal (unmark interested) and Scan Confirmation are handled here so that
//    watchers get a consistent view (single source of truth for side-effects).
// 7) Scan confirmation MUST NOT remove the shout-out from the interested list;
//    removal happens only after the user votes (thumbs up/down).
//
// Efficient Fetching & Hydration (Read Path)
// ------------------------------------------
//  A) Get interested shout-outs for current user:
//     - Query: shoutOutInterests where uid == currentUserId  (or
//       a field inside shoutOut doc like interestedBy[uid] == true, depending on schema).
//     - Then fetch the referenced ShoutOut docs.
//
//  B) Collect unique creatorIds from the fetched shout-outs.
//     - Use a Set<String> for uniqueness.
//
//  C) Batch-fetch creators from `users` collection using chunked `whereIn`.
//     - Firestore whereIn limit: 10 IDs per query. Chunk creatorIds into size 10.
//     - For each chunk: users.where(FieldPath.documentId, whereIn: chunk)
//     - Merge all results into Map<String, User> by id.
//
//  D) Hydrate shout-outs in memory:
//     - For each ShoutOut s: if usersMap contains s.creatorId →
//         s = s.copyWith(creatorUser: some(usersMap[s.creatorId]))
//       else keep `none()`.
//
//  E) Emit hydrated list once (preferred):
//     - Wait until users are fetched in batches, then emit a single hydrated list.
//     - This keeps UI/BLoC simple and avoids double renders. Use placeholders only
//       if your UI shows items before the repository response arrives.
//     - If a shout-out is scan-confirmed but awaiting vote, it should still be
//       present in the interested list (UI flips to voting mode). Only after a
//       successful vote submission should it be dismissed from the list.

// Write Path (MVP semantics)
// --------------------------
//  * Dismiss (Unmark Interested):
//    - Remove current user’s interested reference for shoutOutId.
//    - Optionally decrement an interestedCount on ShoutOut (if modelled).
//    - Notify watchers so Interested list updates.
//
//  * Scan Confirmation (match payload to shoutOutId):
//    - Create a handshake/confirmation record (e.g., handshakes/{id}) with
//      {shoutOutId, scannerUserId, creatorId, timestamp, version, rawPayload?}.
//    - Do NOT remove from the current user’s interested list yet.
//    - Emit watcher updates so the UI can render the card in "awaiting vote" mode.
//
//  * Vote Submission (👍/👎) — handled by Transactions/Karma repo or here if unified:
//    - Persist the vote (e.g., transactions/karmaVotes) and any aggregates.
//    - After successful vote, dismiss the shout-out from the interested list for
//      the voter. This is the moment we remove it from their list.
//    - Idempotent operations recommended (repeat submits are no-ops).
//
// Streaming Implementation Tips
// -----------------------------
// - Combine streams in the repository and perform hydration in asyncMap; emit a
//   single hydrated list per shoutOuts change (no progressive double-emits).
// - Maintain a small in-memory cache: Map<String, User> userCache; hydrate
//   from cache first, then fetch missing IDs; still emit once when hydration completes.
//
// Caching Strategy (small & pragmatic)
// ------------------------------------
// - userCache with a basic TTL (e.g., DateTime insertedAt) if needed.
// - On every new shoutOuts emission:
//   * missing = creatorIds - userCache.keys
//   * if missing.isNotEmpty → fetch in chunks and update cache.
//   * hydrate using cache without waiting for re-fetched users already present.
//
// Error Handling
// --------------
// - If user fetch fails for some IDs, log and proceed with `none()` to avoid blocking the list.
// - Repository returns Either<Failure, Stream<List<ShoutOut>>> or directly Stream<Either<Failure, List<ShoutOut>>> per your existing pattern.
//
// DTO Boundary
// ------------
// - ShoutOutDto must NOT include creatorUser.
// - Mapping:
//     * fromDomain: ignore creatorUser
//     * toDomain: set creatorUser: none()
// - Hydration happens AFTER toDomain, inside this repository.
//
// Pseudocode Sketch (for future implementation)
// --------------------------------------------
// Future< List<ShoutOut> > hydrateUsers(List<ShoutOut> items) async {
//   final ids = items.map((s) => s.creatorId.getOrCrash()).toSet();
//   final missing = ids.where((id) => !userCache.containsKey(id)).toList();
//   for (final chunk in chunksOf(missing, 10)) {
//     final users = await usersCol.where(FieldPath.documentId, whereIn: chunk).get();
//     for (final doc in users.docs) { userCache[doc.id] = UserDto.fromFirestore(doc).toDomain(); }
//   }
//   return items.map((s) {
//     final id = s.creatorId.getOrCrash();
//     final u = userCache[id];
//     return u != null ? s.copyWith(creatorUser: some(u)) : s; // otherwise none()
//   }).toList(growable: false);
// }
//
// Notes on Dev vs Prod
// --------------------
// - Dev repo can fabricate creatorUser inline (always hydrated) to simplify UI work.
// - Prod repo follows the batching + cache flow above for efficiency.
// - Dev repo: may fabricate scan confirmation and set an in-memory flag that
//   flips cards into voting mode without removing them until a vote is submitted.
//
// Testing Pointers
// ----------------
// - Unit test: missing users fetch → hydrated results include some(user) on the single emission.
// - Unit test: subset already cached → only missing IDs are fetched; still a single emission returned.
// - Unit test: failure path → returns with none() for missing users but does not fail the whole list.
// - Widget test: InterestedShoutOutsTab renders the hydrated list from the single emission.
// - Unit test: scan confirmation leaves the item in the interested list but sets
//   an "awaiting vote" flag/state so UI toggles buttons.
// - Unit test: after vote success, the item is removed from the interested list
//   (dismissed) and watchers emit the updated list.
//
// Performance Tips
// ----------------
// - Minimize reads: chunked whereIn + cache hits should keep queries low; emit once per change.
// - Prefer a single re-hydration emission per shoutOuts change (unless UX demands progressive updates).
// - Avoid per-item reads (no N+1). Always batch by unique IDs.
//
// ignore_for_file: lines_longer_than_80_chars

// End of strategy notes.
