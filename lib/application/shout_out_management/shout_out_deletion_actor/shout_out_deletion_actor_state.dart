part of 'shout_out_deletion_actor_bloc.dart';

/// Shout Out Deletion Actor State
@freezed
class ShoutOutDeletionActorState with _$ShoutOutDeletionActorState {
  /// Initial state
  const factory ShoutOutDeletionActorState.initial() = _Initial;

  /// Action in progress state
  const factory ShoutOutDeletionActorState.actionInProgress() =
      _ActionInProgress;

  /// Deletion success state
  const factory ShoutOutDeletionActorState.deletionSuccess() = _DeletionSuccess;

  /// Deletion failure state
  const factory ShoutOutDeletionActorState.deletionFailure(
    Failure failure,
  ) = _LoadFailure;
}
