part of 'user_deletion_actor_bloc.dart';

/// User deletion state.
@freezed
class UserDeletionActorState with _$UserDeletionActorState {
  /// Initial state.
  const factory UserDeletionActorState.initial() = _Initial;

  /// Action in progress state.
  const factory UserDeletionActorState.actionInProgress() = _ActionInProgress;

  /// Deletion success state.
  const factory UserDeletionActorState.deletionSuccess() = _DeletionSuccess;

  /// Deletion failure state.
  const factory UserDeletionActorState.deletionFailure(
    Failure failure,
  ) = _DeletionFailure;
}
