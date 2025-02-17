part of 'interested_shout_outs_watcher_bloc.dart';

/// Interested shout outs watcher event
@freezed
class InterestedShoutOutsWatcherEvent with _$InterestedShoutOutsWatcherEvent {
  /// Watch started event
  const factory InterestedShoutOutsWatcherEvent.watchStarted() = _WatchStarted;

  /// Shout outs received event
  const factory InterestedShoutOutsWatcherEvent.shoutOutsReceived(
    Either<Failure, Set<ShoutOut>> result,
  ) = _ShoutOutsReceived;
}
