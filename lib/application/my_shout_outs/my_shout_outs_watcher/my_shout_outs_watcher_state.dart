part of 'my_shout_outs_watcher_bloc.dart';

/// My shout outs watcher state
@freezed
sealed class MyShoutOutsWatcherState with _$MyShoutOutsWatcherState {
  /// Initial state
  const factory MyShoutOutsWatcherState.initial() = Initial;

  /// Action in progress state
  const factory MyShoutOutsWatcherState.actionInProgress() = ActionInProgress;

  /// Load success state
  const factory MyShoutOutsWatcherState.loadSuccess(
    Set<ShoutOut> shoutOuts,
  ) = LoadSuccess;

  /// Load failure state
  const factory MyShoutOutsWatcherState.loadFailure(
    Failure failure,
  ) = LoadFailure;
}
