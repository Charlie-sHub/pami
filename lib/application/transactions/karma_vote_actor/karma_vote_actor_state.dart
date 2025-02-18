part of 'karma_vote_actor_bloc.dart';

/// Karma vote state
@freezed
class KarmaVoteActorState with _$KarmaVoteActorState {
  /// Vote initial state
  const factory KarmaVoteActorState.initial() = _Initial;

  /// Vote in progress state
  const factory KarmaVoteActorState.actionInProgress() = _VoteInProgress;

  /// Vote success state
  const factory KarmaVoteActorState.voteSuccess() = _VoteSuccess;

  /// Vote failure state
  const factory KarmaVoteActorState.voteFailure(
    Failure failure,
  ) = _VoteFailure;
}
