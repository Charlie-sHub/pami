part of 'notifications_watcher_bloc.dart';

/// Notification watcher state
@freezed
sealed class NotificationsWatcherState with _$NotificationsWatcherState {
  /// Initial state
  const factory NotificationsWatcherState.initial() = Initial;

  /// Action in progress state
  const factory NotificationsWatcherState.loadInProgress() = LoadInProgress;

  /// Load success state
  const factory NotificationsWatcherState.loadSuccess(
    List<Notification> notifications,
  ) = LoadSuccess;

  /// Load failure state
  const factory NotificationsWatcherState.loadFailure(
    Failure failure,
  ) = LoadFailure;
}
