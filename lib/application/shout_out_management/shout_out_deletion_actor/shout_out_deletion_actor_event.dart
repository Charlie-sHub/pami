part of 'shout_out_deletion_actor_bloc.dart';

/// Shout Out Deletion Actor Events
@freezed
sealed class ShoutOutDeletionActorEvent with _$ShoutOutDeletionActorEvent {
  /// Delete Requested  event
  const factory ShoutOutDeletionActorEvent.deleteRequested({
    required UniqueId shoutOutId,
  }) = _DeleteRequested;
}
