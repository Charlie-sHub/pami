part of 'shout_out_deletion_actor_bloc.dart';

/// Shout Out Deletion Actor Events
@freezed
class ShoutOutDeletionActorEvent with _$ShoutOutDeletionActorEvent {
  /// Delete Requested  event
  const factory ShoutOutDeletionActorEvent.deleteRequested(
    UniqueId shoutOutId,
  ) = _DeleteRequested;
}
