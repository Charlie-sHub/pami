part of 'home_navigation_actor_bloc.dart';

/// Home navigation event
@freezed
sealed class HomeNavigationActorEvent with _$HomeNavigationActorEvent {
  /// Bottom navigation tapped event
  const factory HomeNavigationActorEvent.tabSelected(int index) = _TabSelected;
}
