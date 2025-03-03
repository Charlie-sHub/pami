part of 'notification_actor_bloc.dart';

/// Notification actor state
@freezed
sealed class NotificationActorState with _$NotificationActorState {
  /// Initial state
  const factory NotificationActorState.initial() = Initial;

  /// Action in progress state
  const factory NotificationActorState.actionInProgress() = ActionInProgress;

  /// Read success state
  const factory NotificationActorState.readMarkSuccess() = ReadMarkSuccess;

  /// Deletion success state
  const factory NotificationActorState.deletionSuccess() = DeletionSuccess;

  /// Deletion failure state
  const factory NotificationActorState.deletionFailure(
    Failure failure,
  ) = DeletionFailure;
}
