part of 'home_navigation_bloc.dart';

/// Home navigation state
@freezed
class HomeNavigationState with _$HomeNavigationState {
  /// Home navigation state
  const factory HomeNavigationState({
    @Default(0) int currentIndex,
  }) = _HomeNavigationState;
}
