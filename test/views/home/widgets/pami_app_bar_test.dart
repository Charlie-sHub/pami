import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/home/home_navigation_actor/home_navigation_actor_bloc.dart';
import 'package:pami/application/notifications/notifications_watcher/notifications_watcher_bloc.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/home/misc/navigation_indexes.dart';
import 'package:pami/views/home/widgets/notifications_button.dart';
import 'package:pami/views/home/widgets/pami_app_bar.dart';
import 'package:pami/views/home/widgets/settings_button.dart';

import 'pami_app_bar_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NotificationsWatcherBloc>(),
  MockSpec<HomeNavigationActorBloc>(),
])
void main() {
  late MockNotificationsWatcherBloc mockNotificationsWatcherBloc;
  late MockHomeNavigationActorBloc mockHomeNavigationActorBloc;

  setUp(
    () {
      mockHomeNavigationActorBloc = MockHomeNavigationActorBloc();
      mockNotificationsWatcherBloc = MockNotificationsWatcherBloc();
      getIt.registerFactory<NotificationsWatcherBloc>(
        () => mockNotificationsWatcherBloc,
      );
      provideDummy<NotificationsWatcherState>(
        const NotificationsWatcherState.initial(),
      );
    },
  );

  tearDown(
    () async {
      await mockNotificationsWatcherBloc.close();
      await mockHomeNavigationActorBloc.close();
      await getIt.reset();
    },
  );

  Widget buildWidget() => MaterialApp(
        home: BlocProvider<HomeNavigationActorBloc>(
          create: (context) => mockHomeNavigationActorBloc,
          child: const Scaffold(
            appBar: PamiAppBar(),
          ),
        ),
      );

  testWidgets(
    'PamiAppBar renders correctly',
    (tester) async {
      // Arrange
      when(mockHomeNavigationActorBloc.state).thenReturn(
        const HomeNavigationActorState(),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(NotificationsButton), findsOneWidget);
      expect(find.byType(SettingsButton), findsOneWidget);
    },
  );

  testWidgets(
    'PamiAppBar shows "Map" title on Map view',
    (tester) async {
      // Arrange
      when(mockHomeNavigationActorBloc.state).thenReturn(
        const HomeNavigationActorState(),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Map'), findsOneWidget);
    },
  );

  testWidgets(
    'PamiAppBar shows "Interests" title on Interested Shout Outs view',
    (tester) async {
      // Arrange
      when(mockHomeNavigationActorBloc.state).thenReturn(
        const HomeNavigationActorState(
          currentIndex: NavigationIndexes.interestedShoutOutsView,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Interests'), findsOneWidget);
    },
  );

  testWidgets(
    'PamiAppBar shows "My Shout Outs" title on My Shout Outs view',
    (tester) async {
      // Arrange
      when(mockHomeNavigationActorBloc.state).thenReturn(
        const HomeNavigationActorState(
          currentIndex: NavigationIndexes.myShoutOutsView,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('My Shout Outs'), findsOneWidget);
    },
  );

  testWidgets(
    'PamiAppBar shows "Profile" title on Profile view',
    (tester) async {
      // Arrange
      when(mockHomeNavigationActorBloc.state).thenReturn(
        const HomeNavigationActorState(
          currentIndex: NavigationIndexes.profileView,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Profile'), findsOneWidget);
    },
  );

  testWidgets(
    'PamiAppBar shows "Notifications" title on Notifications view',
    (tester) async {
      // Arrange
      when(mockHomeNavigationActorBloc.state).thenReturn(
        const HomeNavigationActorState(
          currentIndex: NavigationIndexes.notificationsView,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Notifications'), findsOneWidget);
    },
  );

  testWidgets(
    'PamiAppBar shows "Unknown View" title on unknown index',
    (tester) async {
      // Arrange
      when(mockHomeNavigationActorBloc.state).thenReturn(
        const HomeNavigationActorState(currentIndex: 100),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Unknown View'), findsOneWidget);
    },
  );
}
