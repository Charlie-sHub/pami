part of 'my_shout_outs_watcher_bloc.dart';

/// My shout outs watcher state
@freezed
class MyShoutOutsWatcherState with _$MyShoutOutsWatcherState {
  /// Initial state
  const factory MyShoutOutsWatcherState.initial() = _Initial;

  /// Action in progress state
  const factory MyShoutOutsWatcherState.actionInProgress() = _ActionInProgress;

  /// Load success state
  const factory MyShoutOutsWatcherState.loadSuccess(
    Set<ShoutOut> shoutOuts,
  ) = _LoadSuccess;

  /// Load failure state
  const factory MyShoutOutsWatcherState.loadFailure(
    Failure failure,
  ) = _LoadFailure;
}
