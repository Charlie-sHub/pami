part of 'notification_actor_bloc.dart';

/// Notification actor state
@freezed
class NotificationActorState with _$NotificationActorState {
  /// Initial state
  const factory NotificationActorState.initial() = _Initial;

  /// Action in progress state
  const factory NotificationActorState.actionInProgress() = _ActionInProgress;

  /// Read success state
  const factory NotificationActorState.readMarkSuccess() = _ReadMarkSuccess;

  /// Deletion success state
  const factory NotificationActorState.deletionSuccess() = _DeletionSuccess;

  /// Deletion failure state
  const factory NotificationActorState.deletionFailure(
    Failure failure,
  ) = _DeletionFailure;
}
