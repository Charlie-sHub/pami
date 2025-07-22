part of 'interested_shout_outs_actor_bloc.dart';

/// Interested ShoutOut state
@freezed
sealed class InterestedShoutOutsActorState
    with _$InterestedShoutOutsActorState {
  /// Initial state
  const factory InterestedShoutOutsActorState.initial() = Initial;

  /// Action in progress state
  const factory InterestedShoutOutsActorState.actionInProgress() =
      ActionInProgress;

  /// Addition success state
  const factory InterestedShoutOutsActorState.additionSuccess() =
      AdditionSuccess;

  /// Addition failure state
  const factory InterestedShoutOutsActorState.additionFailure(
    Failure failure,
  ) = AdditionFailure;
}
