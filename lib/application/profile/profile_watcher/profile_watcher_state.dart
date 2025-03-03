part of 'profile_watcher_bloc.dart';

/// Profile watcher state
@freezed
sealed class ProfileWatcherState with _$ProfileWatcherState {
  /// Initial state
  const factory ProfileWatcherState.initial() = Initial;

  /// Action in progress
  const factory ProfileWatcherState.loadInProgress() = LoadInProgress;

  /// Load success
  const factory ProfileWatcherState.loadSuccess(
    User user,
  ) = LoadSuccess;

  /// Load failure
  const factory ProfileWatcherState.loadFailure(
    Failure failure,
  ) = LoadFailure;
}
