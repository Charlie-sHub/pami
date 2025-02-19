part of 'notifications_watcher_bloc.dart';

/// Notification watcher state
@freezed
class NotificationsWatcherState with _$NotificationsWatcherState {
  /// Initial state
  const factory NotificationsWatcherState.initial() = _Initial;

  /// Action in progress state
  const factory NotificationsWatcherState.loadInProgress() = _LoadInProgress;

  /// Load success state
  const factory NotificationsWatcherState.loadSuccess(
    List<Notification> notifications,
  ) = _LoadSuccess;

  /// Load failure state
  const factory NotificationsWatcherState.loadFailure(
    Failure failure,
  ) = _LoadFailure;
}
