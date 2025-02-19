part of 'notifications_watcher_bloc.dart';

/// Notifications watcher event
@freezed
class NotificationsWatcherEvent with _$NotificationsWatcherEvent {
  /// Watch started event
  const factory NotificationsWatcherEvent.watchStarted() = _WatchStarted;

  /// Notifications received event
  const factory NotificationsWatcherEvent.notificationsReceived(
    Either<Failure, List<Notification>> failureOrNotifications,
  ) = _NotificationsReceived;
}
