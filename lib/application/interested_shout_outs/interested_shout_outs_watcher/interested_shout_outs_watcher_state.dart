part of 'interested_shout_outs_watcher_bloc.dart';

/// Interested shout outs watcher state
@freezed
sealed class InterestedShoutOutsWatcherState
    with _$InterestedShoutOutsWatcherState {
  /// Initial state
  const factory InterestedShoutOutsWatcherState.initial() = Initial;

  /// Action in progress state
  const factory InterestedShoutOutsWatcherState.actionInProgress() =
      ActionInProgress;

  /// Load success state
  const factory InterestedShoutOutsWatcherState.loadSuccess(
    List<ShoutOut> shoutOuts,
  ) = LoadSuccess;

  /// Load failure state
  const factory InterestedShoutOutsWatcherState.loadFailure(
    Failure failure,
  ) = LoadFailure;
}
