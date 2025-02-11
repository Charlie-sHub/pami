part of 'home_navigation_bloc.dart';

/// Home navigation event
@freezed
class HomeNavigationEvent with _$HomeNavigationEvent {
  /// Bottom navigation tapped event
  const factory HomeNavigationEvent.tabSelected(int index) = _TabSelected;
}
