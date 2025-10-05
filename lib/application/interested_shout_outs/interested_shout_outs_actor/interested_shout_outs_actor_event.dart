part of 'interested_shout_outs_actor_bloc.dart';

/// Interested ShoutOut event
@freezed
sealed class InterestedShoutOutsActorEvent
    with _$InterestedShoutOutsActorEvent {
  /// Add to interested event
  const factory InterestedShoutOutsActorEvent.addToInterested({
    required UniqueId shoutOutId,
  }) = _AddToInterested;

  /// Dismiss to interested event
  const factory InterestedShoutOutsActorEvent.dismissFromInterested({
    required UniqueId shoutOutId,
  }) = _DismissFromInterested;

  /// Scan completed event
  const factory InterestedShoutOutsActorEvent.scanCompleted({
    required UniqueId shoutOutId,
    required String payload,
  }) = _ScanCompleted;
}
