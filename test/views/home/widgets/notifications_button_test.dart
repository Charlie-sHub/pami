import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/home/home_navigation_actor/home_navigation_actor_bloc.dart';
import 'package:pami/application/notifications/notifications_watcher/notifications_watcher_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/home/misc/navigation_indexes.dart';
import 'package:pami/views/home/widgets/notifications_button.dart';

import 'notifications_button_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NotificationsWatcherBloc>(),
  MockSpec<HomeNavigationActorBloc>(),
])
void main() {
  late MockNotificationsWatcherBloc mockNotificationsWatcherBloc;
  late MockHomeNavigationActorBloc mockHomeNavigationActorBloc;

  setUp(
    () {
      mockNotificationsWatcherBloc = MockNotificationsWatcherBloc();
      mockHomeNavigationActorBloc = MockHomeNavigationActorBloc();
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
          child: const Scaffold(body: NotificationsButton()),
        ),
      );

  testWidgets(
    'NotificationsButton renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.notifications), findsOneWidget);
    },
  );

  testWidgets(
    'NotificationsButton shows active icon on LoadSuccess '
    'with new notifications',
    (tester) async {
      // Arrange
      final state = NotificationsWatcherState.loadSuccess(
        [getValidNotification()],
      );
      when(mockNotificationsWatcherBloc.state).thenReturn(state);

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byIcon(Icons.notifications_on_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'NotificationsButton shows inactive icon on LoadSuccess with '
    'no notifications',
    (tester) async {
      // Arrange
      const state = NotificationsWatcherState.loadSuccess([]);
      when(mockNotificationsWatcherBloc.state).thenReturn(state);

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byIcon(Icons.notifications), findsOneWidget);
    },
  );

  testWidgets(
    'NotificationsButton shows inactive icon on Initial state',
    (tester) async {
      // Arrange
      when(mockNotificationsWatcherBloc.state).thenReturn(
        const NotificationsWatcherState.initial(),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byIcon(Icons.notifications), findsOneWidget);
    },
  );

  testWidgets(
    'NotificationsButton shows inactive icon on LoadInProgress state',
    (tester) async {
      // Arrange
      when(mockNotificationsWatcherBloc.state).thenReturn(
        const NotificationsWatcherState.loadInProgress(),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byIcon(Icons.notifications), findsOneWidget);
    },
  );

  testWidgets(
    'NotificationsButton shows inactive icon on LoadFailure state',
    (tester) async {
      // Arrange
      when(mockNotificationsWatcherBloc.state).thenReturn(
        const NotificationsWatcherState.loadFailure(
          Failure.notFoundError(),
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byIcon(Icons.notifications), findsOneWidget);
    },
  );

  testWidgets(
    'NotificationsButton dispatches '
    'HomeNavigationActorEvent.tabSelected on tap',
    (tester) async {
      // Arrange
      when(mockHomeNavigationActorBloc.state).thenReturn(
        const HomeNavigationActorState(),
      );
      when(mockNotificationsWatcherBloc.state).thenReturn(
        const NotificationsWatcherState.initial(),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Assert
      verify(
        mockHomeNavigationActorBloc.add(
          const HomeNavigationActorEvent.tabSelected(
            NavigationIndexes.notificationsView,
          ),
        ),
      ).called(1);
    },
  );
}
