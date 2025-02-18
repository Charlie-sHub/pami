part of 'karma_vote_actor_bloc.dart';

/// Karma vote event
@freezed
class KarmaVoteActorEvent with _$KarmaVoteActorEvent {
  /// Vote submitted event
  const factory KarmaVoteActorEvent.voteSubmitted({
    required UniqueId transactionId,
    required bool isPositive,
  }) = _VoteSubmitted;
}
