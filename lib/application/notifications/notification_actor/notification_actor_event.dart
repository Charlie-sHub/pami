part of 'notification_actor_bloc.dart';

/// Notification actor event
@freezed
sealed class NotificationActorEvent with _$NotificationActorEvent {
  /// Mark as read event
  const factory NotificationActorEvent.markAsRead(
    UniqueId notificationId,
  ) = _MarkAsRead;

  /// Delete notification event
  const factory NotificationActorEvent.deleteNotification(
    UniqueId notificationId,
  ) = _DeleteNotification;
}
