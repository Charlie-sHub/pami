import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/application/home/home_navigation_actor/home_navigation_actor_bloc.dart';

void main() {
  late HomeNavigationActorBloc homeNavigationBloc;

  setUp(
    () {
      homeNavigationBloc = HomeNavigationActorBloc();
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<HomeNavigationActorBloc, HomeNavigationActorState>(
        'emits [currentIndex: 2] when tabSelected is added with index 2',
        build: () => homeNavigationBloc,
        act: (bloc) => bloc.add(const HomeNavigationActorEvent.tabSelected(2)),
        expect: () => [
          const HomeNavigationActorState(currentIndex: 2),
        ],
      );

      blocTest<HomeNavigationActorBloc, HomeNavigationActorState>(
        'emits [currentIndex: 0] when tabSelected is added with index 0',
        build: () => homeNavigationBloc,
        act: (bloc) => bloc.add(const HomeNavigationActorEvent.tabSelected(0)),
        expect: () => [
          const HomeNavigationActorState(),
        ],
      );

      blocTest<HomeNavigationActorBloc, HomeNavigationActorState>(
        'emits [currentIndex: 4] when tabSelected is added with index 4',
        build: () => homeNavigationBloc,
        act: (bloc) => bloc.add(const HomeNavigationActorEvent.tabSelected(4)),
        expect: () => [
          const HomeNavigationActorState(currentIndex: 4),
        ],
      );
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<HomeNavigationActorBloc, HomeNavigationActorState>(
        'emits [currentIndex: 0] when tabSelected is added with index -1',
        build: () => homeNavigationBloc,
        act: (bloc) => bloc.add(const HomeNavigationActorEvent.tabSelected(-1)),
        expect: () => [
          const HomeNavigationActorState(),
        ],
      );

      blocTest<HomeNavigationActorBloc, HomeNavigationActorState>(
        'emits [currentIndex: 0] when tabSelected is added with index 5',
        build: () => homeNavigationBloc,
        act: (bloc) => bloc.add(const HomeNavigationActorEvent.tabSelected(5)),
        expect: () => [
          const HomeNavigationActorState(),
        ],
      );
    },
  );
}
