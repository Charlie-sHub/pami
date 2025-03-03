part of 'profile_watcher_bloc.dart';

/// Profile watcher event
@freezed
sealed class ProfileWatcherEvent with _$ProfileWatcherEvent {
  /// Fetch profile
  const factory ProfileWatcherEvent.fetchProfile() = _FetchProfile;
}
