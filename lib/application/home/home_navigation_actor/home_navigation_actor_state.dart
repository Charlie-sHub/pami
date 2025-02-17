part of 'home_navigation_actor_bloc.dart';

/// Home navigation state
@freezed
class HomeNavigationActorState with _$HomeNavigationActorState {
  /// Home navigation state
  const factory HomeNavigationActorState({
    @Default(0) int currentIndex,
  }) = _HomeNavigationActorState;
}
