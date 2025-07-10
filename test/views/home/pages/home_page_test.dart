import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/home/home_navigation_actor/home_navigation_actor_bloc.dart';
import 'package:pami/application/notifications/notifications_watcher/notifications_watcher_bloc.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/home/misc/navigation_indexes.dart';
import 'package:pami/views/home/pages/home_page.dart';
import 'package:pami/views/home/widgets/create_shout_out_floating_button.dart';
import 'package:pami/views/home/widgets/pami_app_bar.dart';
import 'package:pami/views/home/widgets/pami_bottom_navigation_bar.dart';
import 'package:pami/views/interested_shout_outs/widgets/interested_shout_outs_view.dart';
import 'package:pami/views/map/widgets/map_view.dart';
import 'package:pami/views/my_shout_outs/widgets/my_shout_outs_view.dart';
import 'package:pami/views/notifications/widgets/notifications_view.dart';
import 'package:pami/views/profile/widgets/profile_view.dart';

import 'home_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HomeNavigationActorBloc>(),
  MockSpec<NotificationsWatcherBloc>(),
])
void main() {
  late MockHomeNavigationActorBloc mockNavigationBloc;
  late MockNotificationsWatcherBloc mockNotificationsBloc;

  setUp(
    () {
      TestWidgetsFlutterBinding.ensureInitialized();
      mockNavigationBloc = MockHomeNavigationActorBloc();
      mockNotificationsBloc = MockNotificationsWatcherBloc();
      getIt
        ..registerFactory<HomeNavigationActorBloc>(
          () => mockNavigationBloc,
        )
        ..registerFactory<NotificationsWatcherBloc>(
          () => mockNotificationsBloc,
        );
      provideDummy<NotificationsWatcherState>(
        const NotificationsWatcherState.initial(),
      );
    },
  );

  tearDown(
    () async {
      await mockNavigationBloc.close();
      await getIt.reset();
    },
  );

  Widget buildWidget() => const MaterialApp(
        home: HomePage(),
      );

  testWidgets(
    'HomePage renders correctly',
    (tester) async {
      // Arrange
      when(mockNavigationBloc.state).thenReturn(
        const HomeNavigationActorState(),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(PamiAppBar), findsOneWidget);
      expect(find.byType(PamiBottomNavigationBar), findsOneWidget);
      expect(find.byType(CreateShoutOutFloatingButton), findsOneWidget);
      expect(find.byType(IndexedStack), findsOneWidget);
    },
  );

  testWidgets(
    'HomePage shows MapView',
    (tester) async {
      // Arrange
      when(mockNavigationBloc.state).thenReturn(
        const HomeNavigationActorState(),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(MapView), findsOneWidget);
      expect(find.byType(InterestedShoutOutsView), findsNothing);
      expect(find.byType(MyShoutOutsView), findsNothing);
      expect(find.byType(ProfileView), findsNothing);
      expect(find.byType(NotificationsView), findsNothing);
    },
  );

  testWidgets(
    'HomePage shows InterestedShoutOutsView',
    (tester) async {
      // Arrange
      when(mockNavigationBloc.state).thenReturn(
        const HomeNavigationActorState(
          currentIndex: NavigationIndexes.interestedShoutOutsView,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(InterestedShoutOutsView), findsOneWidget);
      expect(find.byType(MapView), findsNothing);
      expect(find.byType(MyShoutOutsView), findsNothing);
      expect(find.byType(ProfileView), findsNothing);
      expect(find.byType(NotificationsView), findsNothing);
    },
  );

  testWidgets(
    'HomePage shows MyShoutOutsView',
    (tester) async {
      // Arrange
      when(mockNavigationBloc.state).thenReturn(
        const HomeNavigationActorState(
          currentIndex: NavigationIndexes.myShoutOutsView,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(MyShoutOutsView), findsOneWidget);
      expect(find.byType(InterestedShoutOutsView), findsNothing);
      expect(find.byType(MapView), findsNothing);
      expect(find.byType(ProfileView), findsNothing);
      expect(find.byType(NotificationsView), findsNothing);
    },
  );

  testWidgets(
    'HomePage shows ProfileView',
    (tester) async {
      // Arrange
      when(mockNavigationBloc.state).thenReturn(
        const HomeNavigationActorState(
          currentIndex: NavigationIndexes.profileView,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.byType(MyShoutOutsView), findsNothing);
      expect(find.byType(InterestedShoutOutsView), findsNothing);
      expect(find.byType(MapView), findsNothing);
      expect(find.byType(NotificationsView), findsNothing);
    },
  );

  testWidgets(
    'HomePage shows NotificationsView',
    (tester) async {
      // Arrange
      when(mockNavigationBloc.state).thenReturn(
        const HomeNavigationActorState(
          currentIndex: NavigationIndexes.notificationsView,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(NotificationsView), findsOneWidget);
      expect(find.byType(ProfileView), findsNothing);
      expect(find.byType(MyShoutOutsView), findsNothing);
      expect(find.byType(InterestedShoutOutsView), findsNothing);
      expect(find.byType(MapView), findsNothing);
    },
  );
}
