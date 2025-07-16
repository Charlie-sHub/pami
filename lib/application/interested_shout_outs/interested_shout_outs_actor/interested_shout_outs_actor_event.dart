part of 'interested_shout_outs_actor_bloc.dart';

/// Interested ShoutOut event
@freezed
sealed class InterestedShoutOutsActorEvent
    with _$InterestedShoutOutsActorEvent {
  /// Add to interested event
  const factory InterestedShoutOutsActorEvent.addToInterested({
    required UniqueId shoutOutId,
  }) = _AddToInterested;
}
