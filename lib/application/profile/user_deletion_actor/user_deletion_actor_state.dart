part of 'user_deletion_actor_bloc.dart';

/// User deletion state.
@freezed
sealed class UserDeletionActorState with _$UserDeletionActorState {
  /// Initial state.
  const factory UserDeletionActorState.initial() = Initial;

  /// Action in progress state.
  const factory UserDeletionActorState.actionInProgress() = ActionInProgress;

  /// Deletion success state.
  const factory UserDeletionActorState.deletionSuccess() = DeletionSuccess;

  /// Deletion failure state.
  const factory UserDeletionActorState.deletionFailure(
    Failure failure,
  ) = DeletionFailure;
}
