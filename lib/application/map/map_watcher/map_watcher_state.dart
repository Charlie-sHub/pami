part of 'map_watcher_bloc.dart';

/// Map watcher state
@freezed
class MapWatcherState with _$MapWatcherState {
  /// Initial state
  const factory MapWatcherState.initial() = _Initial;

  /// Action in progress state
  const factory MapWatcherState.actionInProgress() = _ActionInProgress;

  /// Load success state
  const factory MapWatcherState.loadSuccess(
    Set<ShoutOut> shoutOuts,
  ) = _LoadSuccess;

  /// Load failure state
  const factory MapWatcherState.loadFailure(
    Failure failure,
  ) = _LoadFailure;
}
