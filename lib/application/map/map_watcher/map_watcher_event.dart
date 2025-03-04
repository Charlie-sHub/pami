part of 'map_watcher_bloc.dart';

/// Map watcher event
@freezed
sealed class MapWatcherEvent with _$MapWatcherEvent {
  /// Watch started event
  const factory MapWatcherEvent.watchStarted(
    MapSettings settings,
  ) = _WatchStarted;

  /// Results received event
  const factory MapWatcherEvent.resultsReceived(
    Either<Failure, Set<ShoutOut>> result,
  ) = _ResultsReceived;
}
