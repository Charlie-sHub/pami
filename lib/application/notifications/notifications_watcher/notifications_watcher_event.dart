part of 'notifications_watcher_bloc.dart';

/// Notifications watcher event
@freezed
sealed class NotificationsWatcherEvent with _$NotificationsWatcherEvent {
  /// Watch started event
  const factory NotificationsWatcherEvent.watchStarted() = _WatchStarted;

  /// Notifications received event
  const factory NotificationsWatcherEvent.resultsReceived(
    Either<Failure, List<Notification>> result,
  ) = _ResultsReceived;
}
