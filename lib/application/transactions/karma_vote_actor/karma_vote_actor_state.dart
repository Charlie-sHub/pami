part of 'karma_vote_actor_bloc.dart';

/// Karma vote state
@freezed
sealed class KarmaVoteActorState with _$KarmaVoteActorState {
  /// Vote initial state
  const factory KarmaVoteActorState.initial() = Initial;

  /// Vote in progress state
  const factory KarmaVoteActorState.actionInProgress() = VoteInProgress;

  /// Vote success state
  const factory KarmaVoteActorState.voteSuccess() = VoteSuccess;

  /// Vote failure state
  const factory KarmaVoteActorState.voteFailure(
    Failure failure,
  ) = VoteFailure;
}
