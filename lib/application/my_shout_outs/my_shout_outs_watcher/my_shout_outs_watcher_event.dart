part of 'my_shout_outs_watcher_bloc.dart';

/// My shout outs watcher event
@freezed
class MyShoutOutsWatcherEvent with _$MyShoutOutsWatcherEvent {
  /// Watch started event
  const factory MyShoutOutsWatcherEvent.watchStarted() = _WatchStarted;

  /// Shout outs received event
  const factory MyShoutOutsWatcherEvent.shoutOutsReceived(
    Either<Failure, Set<ShoutOut>> result,
  ) = _ShoutOutsReceived;
}
