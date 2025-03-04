part of 'user_deletion_actor_bloc.dart';

/// User deletion event.
@freezed
sealed class UserDeletionActorEvent with _$UserDeletionActorEvent {
  /// Deletion requested event.
  const factory UserDeletionActorEvent.deleteRequested() = _DeleteRequested;
}
