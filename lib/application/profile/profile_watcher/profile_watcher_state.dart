part of 'profile_watcher_bloc.dart';

/// Profile watcher state
@freezed
class ProfileWatcherState with _$ProfileWatcherState {
  /// Initial state
  const factory ProfileWatcherState.initial() = _Initial;

  /// Action in progress
  const factory ProfileWatcherState.loadInProgress() = _LoadInProgress;

  /// Load success
  const factory ProfileWatcherState.loadSuccess(
    User user,
  ) = _LoadSuccess;

  /// Load failure
  const factory ProfileWatcherState.loadFailure(
    Failure failure,
  ) = _LoadFailure;
}
