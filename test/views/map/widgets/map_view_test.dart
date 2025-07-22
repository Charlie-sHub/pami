import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/map/map_controller/map_controller_bloc.dart';
import 'package:pami/application/map/map_settings_form/map_settings_form_bloc.dart';
import 'package:pami/application/map/map_watcher/map_watcher_bloc.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/core/misc/bitmap_icon_loader.dart';
import 'package:pami/views/map/widgets/error_card.dart';
import 'package:pami/views/map/widgets/map_settings_button.dart';
import 'package:pami/views/map/widgets/map_view.dart';
import 'package:pami/views/map/widgets/map_widget.dart';

import 'map_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MapSettingsFormBloc>(),
  MockSpec<MapControllerBloc>(),
  MockSpec<MapWatcherBloc>(),
  MockSpec<BitmapIconLoader>(),
])
void main() {
  late MockMapSettingsFormBloc mockMapSettingsFormBloc;
  late MockMapControllerBloc mockMapControllerBloc;
  late MockMapWatcherBloc mockMapWatcherBloc;
  late MockBitmapIconLoader mockBitmapIconLoader;

  final initialMapSettingsFormState = MapSettingsFormState.initial();
  final initialMapControllerState = MapControllerState.initial();
  const initialMapWatcherState = MapWatcherState.initial();

  setUp(
    () {
      mockMapSettingsFormBloc = MockMapSettingsFormBloc();
      mockMapControllerBloc = MockMapControllerBloc();
      mockMapWatcherBloc = MockMapWatcherBloc();
      mockBitmapIconLoader = MockBitmapIconLoader();

      getIt
        ..registerFactory<MapSettingsFormBloc>(() => mockMapSettingsFormBloc)
        ..registerFactory<MapControllerBloc>(() => mockMapControllerBloc)
        ..registerFactory<MapWatcherBloc>(() => mockMapWatcherBloc)
        ..registerFactory<BitmapIconLoader>(() => mockBitmapIconLoader);

      provideDummy<MapSettingsFormState>(initialMapSettingsFormState);
      provideDummy<MapControllerState>(initialMapControllerState);
      provideDummy<MapWatcherState>(initialMapWatcherState);
    },
  );

  tearDown(() async => getIt.reset());

  Widget buildWidget() => const MaterialApp(
    home: Scaffold(
      body: MapView(),
    ),
  );

  testWidgets(
    'renders MapWidget and MapSettingsButton when MapWatcherBloc '
    'is in initial/loadSuccess state',
    (tester) async {
      when(mockMapControllerBloc.stream).thenAnswer(
        (_) => Stream.value(
          initialMapControllerState.copyWith(
            initialized: true,
          ),
        ),
      );
      const successWatcherState = MapWatcherState.loadSuccess({});
      when(mockMapWatcherBloc.stream).thenAnswer(
        (_) => Stream.value(successWatcherState),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MapWidget), findsOneWidget);
      expect(find.byType(MapSettingsButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ErrorCard), findsNothing);
      verify(
        mockMapControllerBloc.add(
          const MapControllerEvent.locationPermissionRequested(),
        ),
      ).called(1);
      verify(
        mockMapWatcherBloc.add(
          MapWatcherEvent.watchStarted(MapSettings.empty()),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'renders CircularProgressIndicator when MapWatcherBloc is in '
    'actionInProgress state',
    (tester) async {
      // Arrange
      when(mockMapWatcherBloc.stream).thenAnswer(
        (_) => Stream.value(
          const MapWatcherState.actionInProgress(),
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsAtLeast(1));
      expect(find.byType(MapWidget), findsOneWidget);
      expect(find.byType(MapSettingsButton), findsOneWidget);
    },
  );

  testWidgets(
    'renders ErrorCard when MapWatcherBloc is in loadFailure state',
    (tester) async {
      // Arrange
      const testFailure = Failure.serverError(
        errorString: 'Failed to load',
      );
      when(mockMapWatcherBloc.stream).thenAnswer(
        (_) => Stream.value(
          const MapWatcherState.loadFailure(testFailure),
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Assert
      expect(find.byType(ErrorCard), findsOneWidget);
      expect(
        find.widgetWithText(
          ErrorCard,
          'Error loading shout-outs: Server error: Failed to load',
        ),
        findsOneWidget,
      );
      expect(find.byType(MapWidget), findsOneWidget);
      expect(find.byType(MapSettingsButton), findsOneWidget);
    },
  );

  testWidgets(
    'BlocListener on MapSettingsFormBloc adds watchStarted event '
    'to MapWatcherBloc',
    (tester) async {
      // Arrange
      final testSettings = MapSettings(
        radius: MapRadius(5),
        type: ShoutOutType.offer,
        categories: {Category.technology},
      );
      final newMapSettingsFormState = MapSettingsFormState(
        settings: testSettings,
      );
      final controller = StreamController<MapSettingsFormState>.broadcast();
      when(mockMapSettingsFormBloc.stream).thenAnswer(
        (_) => controller.stream,
      );

      // Act
      await tester.pumpWidget(buildWidget());
      controller.add(newMapSettingsFormState);
      await tester.pump();

      // Assert
      verify(
        mockMapWatcherBloc.add(
          MapWatcherEvent.watchStarted(testSettings),
        ),
      ).called(1);
      await controller.close();
    },
  );
}
