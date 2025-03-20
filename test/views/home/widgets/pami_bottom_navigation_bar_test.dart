import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/home/home_navigation_actor/home_navigation_actor_bloc.dart';
import 'package:pami/views/home/widgets/pami_bottom_navigation_bar.dart';

import 'pami_bottom_navigation_bar_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HomeNavigationActorBloc>(),
])
void main() {
  late MockHomeNavigationActorBloc mockHomeNavigationActorBloc;

  setUp(
    () => mockHomeNavigationActorBloc = MockHomeNavigationActorBloc(),
  );

  Widget buildWidget({required int index}) => MaterialApp(
        home: BlocProvider<HomeNavigationActorBloc>(
          create: (context) => mockHomeNavigationActorBloc,
          child: Scaffold(
            body: PamiBottomNavigationBar(index: index),
          ),
        ),
      );

  testWidgets(
    'PamiBottomNavigationBar renders correctly',
    (tester) async {
      // Arrange
      const index = 0;

      // Act
      await tester.pumpWidget(buildWidget(index: index));

      // Assert
      expect(find.byType(AnimatedBottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.explore_rounded), findsOneWidget);
      expect(find.byIcon(Icons.flag_rounded), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'PamiBottomNavigationBar dispatches tabSelected on tap for each tab',
    (tester) async {
      // Arrange
      final icons = [
        Icons.explore_rounded,
        Icons.flag_rounded,
        Icons.bookmark_rounded,
        Icons.person_rounded,
      ];

      for (var i = 0; i < icons.length; i++) {
        when(mockHomeNavigationActorBloc.state).thenReturn(
          HomeNavigationActorState(currentIndex: i),
        );
        when(mockHomeNavigationActorBloc.add(any)).thenReturn(null);

        // Act
        await tester.pumpWidget(buildWidget(index: 0));
        await tester.tap(find.byIcon(icons[i]));
        await tester.pumpAndSettle();

        // Assert
        verify(
          mockHomeNavigationActorBloc.add(
            HomeNavigationActorEvent.tabSelected(i),
          ),
        ).called(1);
      }
    },
  );
}
