import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/application/home/home_navigation/home_navigation_bloc.dart';

void main() {
  late HomeNavigationBloc homeNavigationBloc;

  setUp(
    () {
      homeNavigationBloc = HomeNavigationBloc();
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<HomeNavigationBloc, HomeNavigationState>(
        'emits [currentIndex: 2] when tabSelected is added with index 2',
        build: () => homeNavigationBloc,
        act: (bloc) => bloc.add(const HomeNavigationEvent.tabSelected(2)),
        expect: () => [
          const HomeNavigationState(currentIndex: 2),
        ],
      );

      blocTest<HomeNavigationBloc, HomeNavigationState>(
        'emits [currentIndex: 0] when tabSelected is added with index 0',
        build: () => homeNavigationBloc,
        act: (bloc) => bloc.add(const HomeNavigationEvent.tabSelected(0)),
        expect: () => [
          const HomeNavigationState(),
        ],
      );

      blocTest<HomeNavigationBloc, HomeNavigationState>(
        'emits [currentIndex: 4] when tabSelected is added with index 4',
        build: () => homeNavigationBloc,
        act: (bloc) => bloc.add(const HomeNavigationEvent.tabSelected(4)),
        expect: () => [
          const HomeNavigationState(currentIndex: 4),
        ],
      );
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<HomeNavigationBloc, HomeNavigationState>(
        'emits [currentIndex: 0] when tabSelected is added with index -1',
        build: () => homeNavigationBloc,
        act: (bloc) => bloc.add(const HomeNavigationEvent.tabSelected(-1)),
        expect: () => [
          const HomeNavigationState(),
        ],
      );

      blocTest<HomeNavigationBloc, HomeNavigationState>(
        'emits [currentIndex: 0] when tabSelected is added with index 5',
        build: () => homeNavigationBloc,
        act: (bloc) => bloc.add(const HomeNavigationEvent.tabSelected(5)),
        expect: () => [
          const HomeNavigationState(),
        ],
      );
    },
  );
}
