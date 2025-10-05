# PAMi Project Specification — MVP (Concise)

> **Purpose**: A compact, living spec that orients design, architecture, CI/CD, and security for PAMi’s MVP. It avoids large code dumps and focuses on decisions, interfaces, and conventions the app must follow.

---

## 1) Product Snapshot
- **One‑liner**: Location‑aware “shout‑out” marketplace enabling quick, nearby exchanges.
- **MVP Goals**: fast posting, simple discovery (map + filters), basic chat, QR/manual verification, karma, notifications, onboarding, lightweight analytics.
- **Principles**: DDD layering, vertical feature slices, readability > brevity, security/privacy by design, progressive delivery.

---

## 2) Architecture (DDD + Vertical Slices)
- **Domain**: entities, value objects, failures, repository interfaces. No Flutter/Firebase imports. Invariants at construction.
- **Application**: use‑cases via BLoCs (Form / Watcher / Actor). Orchestrates repos, debounces input, maps `Either<Failure, T>` into UI states. No widgets or IO in BLoCs.
- **Data**: production repositories (Firestore + optional Cloud Functions/external APIs), development repositories (fakes), DTOs with converters, FirestoreX adapter for common patterns.
- **Presentation/Views**: feature‑scoped pages and widgets; reads Application state, emits events only. Auto Route for navigation. Accessibility first.

**State & Errors**
- `flutter_bloc` with explicit states; deduplicate requests; cancel stale watchers.
- Functional errors only (map Firebase/IO exceptions → `Failure`); no raw throws to UI.

---

## 3) MVP Features (Acceptance‑level)
- **Account**: create/edit profile, update email, delete account; show simplified karma.
- **Map View**: radius slider; filters (category, proximity, recency). Results update in ~1s.
- **Shout‑Outs**: post from templates (food/services/items); categorize with tags; edit/close by owner.
- **Messaging**: basic text chat with timestamps; quick reply templates.
- **Transactions**: QR verification + manual fallback; anti‑replay server check if Cloud Function used.
- **Karma**: one vote per party per transaction; deterministic aggregation to profile.
- **Notifications**: “smart alerts” honoring radius/preferences; foreground local, background FCM.
- **History**: per‑user exchange log (date, type, counterpart).
- **Feedback**: in‑app bug/idea form.
- **Onboarding**: first‑run walkthrough; re‑open from Settings.
- **Analytics**: counters (posts, exchanges, karma), minimal PII; opt‑out honored.

---

## 4) Tech Stack & Packages (source of truth = pubspec.yaml)
- **Flutter/Dart**; **Firebase** (Auth, Firestore, Analytics, Crashlytics, Remote Config).
- **Common packages** (non‑exhaustive): `flutter_bloc`, `freezed`, `injectable`, `dartz`, `cloud_firestore`, `firebase_auth`, `firebase_analytics`, `firebase_crashlytics`, sign‑in providers, geo/map and QR libraries, `auto_route`.
- **Conventions**: full, descriptive identifiers (e.g., `sliderController`), avoid acronyms; expression functions and tear‑offs where clearer; readability > brevity.

---

## 5) Domain Layer (Interfaces & VO Policy)
- **Entities** (high‑level): User, ShoutOut, Message, Transaction, KarmaEvent, Notification, Feedback.
- **Value Objects**: EmailAddress, Name, Coordinates(lat, lon), RadiusKm, Minutes, Url, Category, UniqueId.
- **Repository Interfaces**: `IAuthRepository`, `IUserRepository`, `IShoutOutRepository`, `IInterestedShoutOutsRepository`, `IMessageRepository`, `ITransactionRepository`, `IKarmaRepository`, `INotificationRepository`, `IFeedbackRepository`.
- **Return Types**: `Future<Either<Failure, T>>` for commands; `Stream<Either<Failure, T>>` for watchers.

---

## 6) Application Layer (BLoC Behavior)
- **FormBloc**: input management, validation, submit → repo call → success/failure state.
- **WatcherBloc**: stream results with filters; cancel on filter/radius change; emit progress/success/failure.
- **ActorBloc**: discrete actions (e.g., “mark interested”, “verify transaction”), idempotent where applicable.
- **Side‑effects**: surfaced as states/flags only; UI performs navigation/snackbars.

---

## 7) Data Layer (Production Repos, Dev Fakes, FirestoreX)
- **FirestoreX adapter**: centralizes collection/document getters, converters, pagination, geo helpers, server timestamps, batched writes/transactions.
- **Production repositories**: use FirestoreX for reads/writes; handle pagination; use transactions/batches for multi‑doc invariants (e.g., transaction + karma). Messaging stored in subcollections; deterministic id conventions.
- **Dev repositories**: interface‑compatible fakes for fast UI work; deterministic success/failure scenarios.
- **DTO Conventions**: `freezed` + `json_serializable`; UTC timestamps; enums as strings; explicit `fromDomain/toDomain` and `fromJson/toJson`.

---

## 8) Firestore Collections (Discovery‑level; exact fields in DTOs)
- `/users/{userId}` — profile, karma summary, preferences, interestedShoutOutIds.
- `/shoutOuts/{id}` — content, geo (lat/lon/geohash strategy), tags, isOpen, createdAt.
- `/transactions/{id}` — shoutOutId, hostId, guestId, verifiedAt?, method, status.
- `/transactions/{id}/messages/{msgId}` — senderId, text, isRead, createdAt.
- `/karma/{id}` — transactionId, giverId, isPositive, date.
- `/notifications/{id}` — recipientId, description, seen, date.
- `/feedback/{id}` — type, text, userId?, date.

**Indexes**: geo radius, shoutOuts (recency/category), user lookups by interest, messages by createdAt.

---

## 9) Security, Privacy, Compliance
- **Firestore Rules** (versioned in repo; enforced in project): auth required; write only to own resources; validate schema & ownership; scope messaging/transactions to parties; deny privilege escalation.
- **PII Minimization**: store only needed fields; avoid sensitive free‑text.
- **Secrets**: never committed.  
  - **Android/GitHub Actions**: use GitHub **Secrets** (or OIDC) for service accounts and keystores.  
  - **iOS/Xcode Cloud**: use Xcode Cloud **Environment Variables/Secrets** for keys/certs and config.  
- **Privacy Disclosures**: App Store privacy labels; Play Data Safety; clear consent for analytics/notifications.
- **Observability**: Crashlytics, structured logs without secrets/PII.
- **Anti‑replay**: server‑validated nonces/timestamps for QR verification if Cloud Function used.

---

## 10) CI/CD & Release
- **Branching**: `main` (prod), `develop` (staging), feature branches `pami-###-slug`; semantic version + platform build numbers.
- **Quality gates**: `flutter analyze`, unit/widget tests, coverage threshold, dependency audit; fail on regressions.
- **iOS** (**Xcode Cloud**): PRs → internal TestFlight; tags on `main` → App Store. Pre/post scripts: codegen, env injection, bump build, dSYM upload.
- **Android** (**GitHub Actions**): analyze → tests/coverage → build AAB → upload to Play tracks (internal → closed → open → production). VersionCode strategy + release notes from commits.
- **Distribution**: TestFlight, Play tracks, Firebase App Distribution for staging. Remote Config for feature flags; kill‑switches for rollback.
- **Monitoring**: Crash‑free sessions, activation/retention, error budgets for critical flows.

---

## 11) Views/Presentation Conventions
- **Routing**: Auto Route; feature‑scoped routes; deep link support where relevant.
- **Widgets**: small, composable; stateless where possible; no business logic in widgets.
- **UX**: optimistic UI when safe; empty/error states; skeleton loading for lists/map panels.
- **Accessibility**: large tap targets, text scaling, semantic labels; avoid color‑only signals.
- **Localization**: l10n; metric defaults; absolute dates in logs/analytics.

---

## 12) Testing Strategy
- **Domain**: entity/VO invariants; interface contract tests.
- **Application**: Bloc happy‑path and failure‑path; debounce and pagination behavior.
- **Data**: DTO round‑trip; Firestore query behavior (fake/stub); error mapping to Failure.
- **Widgets**: golden tests for core screens; integration flows (login, post, verify).
- **Coverage**: target ≥ 80% initially (configurable).

---

## 13) Coding Standards (Enforced)
- Descriptive identifiers only (e.g., `messageController`, not `msgCtrl`).
- Self‑explanatory code; minimal comments (only for non‑obvious logic).
- Prefer `if (...) { ... } else { ... }` for clarity; avoid early‑return chains if they reduce readability.
- Use `Option`/`Either` for optional/failure paths.
- Centralize config constants and enums; avoid hardcoded “magic” values.
- No secrets, tokens, or PII in logs or examples.

---

## 14) FirestoreX: Minimal Example (pattern only)
*Centralize adapters; repositories call these helpers rather than raw Firestore everywhere.*
```dart
// Example shape (do not copy verbatim):
CollectionReference<UserDto> get userCollection =>
  collection('users').withConverter<UserDto>(
    fromFirestore: (snap, _) => UserDto.fromJson(snap.data()!),
    toFirestore: (dto, _) => dto.toJson(),
  );
// Add: currentUserDoc, shoutOutsNear(center, radiusKm), transactional writes, pagination helpers.
```

---

## 15) Open Questions / Decisions (Keep Updated)
- **Geo strategy & indexing**: For MVP, implement **Option A (pure geohash)** with `{lat, lon, geohash}` and bounding-box queries. Keep door open to **Option B (geo helper lib)** later if complexity grows.
- **Messaging receipts & typing**: **Decided** — per-chat last-read watermark; typing indicators OFF for MVP.
- **QR anti‑replay**: **Pending decision** — Cloud Function validation (nonce + issuedAt + TTL + signature/HMAC) recommended; choose TTL (e.g., 180s) and signature method when implementing.
- **Map clustering & lazy‑load**: **Decided** — use default clustering threshold; lazy-load by viewport with prefetch.
- **Analytics scope & consent**: **Decided** — minimal auth-only events (login/signup attempts & results), no PII, no opt-in for MVP. Revisit if analytics scope expands.
