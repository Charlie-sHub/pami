part of 'map_watcher_bloc.dart';

/// Map watcher state
@freezed
sealed class MapWatcherState with _$MapWatcherState {
  /// Initial state
  const factory MapWatcherState.initial() = Initial;

  /// Action in progress state
  const factory MapWatcherState.actionInProgress() = ActionInProgress;

  /// Load success state
  const factory MapWatcherState.loadSuccess(
    Set<ShoutOut> shoutOuts,
  ) = LoadSuccess;

  /// Load failure state
  const factory MapWatcherState.loadFailure(
    Failure failure,
  ) = LoadFailure;
}
