part of 'interested_shout_outs_watcher_bloc.dart';

/// Interested shout outs watcher state
@freezed
class InterestedShoutOutsWatcherState with _$InterestedShoutOutsWatcherState {
  /// Initial state
  const factory InterestedShoutOutsWatcherState.initial() = _Initial;

  /// Action in progress state
  const factory InterestedShoutOutsWatcherState.actionInProgress() =
      _ActionInProgress;

  /// Load success state
  const factory InterestedShoutOutsWatcherState.loadSuccess(
    Set<ShoutOut> shoutOuts,
  ) = _LoadSuccess;

  /// Load failure state
  const factory InterestedShoutOutsWatcherState.loadFailure(
    Failure failure,
  ) = _LoadFailure;
}
