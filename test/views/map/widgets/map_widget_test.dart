import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/application/map/map_controller/map_controller_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/core/misc/bitmap_icon_loader.dart';
import 'package:pami/views/map/widgets/map_widget.dart';
import 'package:pami/views/map/widgets/shout_out_modal.dart';

import 'map_widget_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MapControllerBloc>(),
  MockSpec<BitmapIconLoader>(),
  MockSpec<InterestedShoutOutsActorBloc>(),
])
void main() {
  late MockMapControllerBloc mockMapControllerBloc;
  late MockBitmapIconLoader mockBitmapIconLoader;
  late MockInterestedShoutOutsActorBloc mockInterestedShoutOutsActorBloc;

  final initialMapControllerState = MapControllerState.initial();

  final defaultBitmapIcons = <String, BitmapDescriptor>{
    'food': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    'other_category': BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen,
    ),
  };

  setUp(
    () {
      mockMapControllerBloc = MockMapControllerBloc();
      mockBitmapIconLoader = MockBitmapIconLoader();
      mockInterestedShoutOutsActorBloc = MockInterestedShoutOutsActorBloc();

      getIt
        ..registerFactory<MapControllerBloc>(
          () => mockMapControllerBloc,
        )
        ..registerFactory<BitmapIconLoader>(
          () => mockBitmapIconLoader,
        )
        ..registerFactory<InterestedShoutOutsActorBloc>(
          () => mockInterestedShoutOutsActorBloc,
        );

      provideDummy<MapControllerState>(
        initialMapControllerState,
      );
      provideDummy<InterestedShoutOutsActorState>(
        const InterestedShoutOutsActorState.initial(),
      );
    },
  );

  tearDown(() async => getIt.reset());

  Widget buildWidget({required Set<ShoutOut> shoutOuts}) =>
      BlocProvider<MapControllerBloc>.value(
        value: mockMapControllerBloc,
        child: MaterialApp(
          home: Scaffold(
            body: MapWidget(shoutOuts: shoutOuts),
          ),
        ),
      );

  group(
    'MapWidget Rendering Logic',
    () {
      testWidgets(
        'renders CircularProgressIndicator while BitmapIconLoader is loading',
        (tester) async {
          // Arrange
          final iconCompleter = Completer<Map<String, BitmapDescriptor>>();
          when(mockBitmapIconLoader.loadAll()).thenAnswer(
            (_) => iconCompleter.future,
          );

          // Act
          await tester.pumpWidget(buildWidget(shoutOuts: const {}));

          // Assert
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.byType(GoogleMap), findsNothing);
          if (!iconCompleter.isCompleted) {
            iconCompleter.complete(defaultBitmapIcons);
          }
        },
      );

      testWidgets(
        'renders CircularProgressIndicator when icons loaded but '
        'MapControllerBloc not initialized',
        (tester) async {
          // Arrange
          final uninitializedMapState = initialMapControllerState.copyWith(
            initialized: false,
          );
          when(mockMapControllerBloc.state).thenReturn(uninitializedMapState);
          when(mockMapControllerBloc.stream).thenAnswer(
            (_) => Stream.value(uninitializedMapState),
          );

          // Act
          await tester.pumpWidget(buildWidget(shoutOuts: const {}));
          await tester.pump();

          // Assert
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.byType(GoogleMap), findsNothing);
        },
      );

      testWidgets(
        'renders GoogleMap when icons loaded and MapControllerBloc initialized',
        (tester) async {
          // Arrange
          final initializedState = initialMapControllerState.copyWith(
            initialized: true,
            coordinates: Coordinates(
              latitude: Latitude(0),
              longitude: Longitude(0),
            ),
            zoom: 15,
          );
          when(mockMapControllerBloc.state).thenReturn(initializedState);
          when(mockMapControllerBloc.stream).thenAnswer(
            (_) => Stream.value(initializedState),
          );

          // Act
          await tester.pumpWidget(buildWidget(shoutOuts: const {}));
          await tester.pumpAndSettle();

          // Assert
          expect(find.byType(GoogleMap), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsNothing);

          final googleMap = tester.widget<GoogleMap>(find.byType(GoogleMap));
          expect(
            googleMap.initialCameraPosition.target.latitude,
            initializedState.coordinates.latitude.getOrCrash(),
          );
          expect(
            googleMap.initialCameraPosition.target.longitude,
            initializedState.coordinates.longitude.getOrCrash(),
          );
          expect(googleMap.initialCameraPosition.zoom, initializedState.zoom);
        },
      );

      testWidgets(
        'handles error from BitmapIconLoader (if widget supports it)',
        (tester) async {
          // Arrange
          when(mockBitmapIconLoader.loadAll()).thenAnswer(
            (_) async => throw Exception('Icon loading failed'),
          );

          // Act
          await tester.pumpWidget(buildWidget(shoutOuts: const {}));
          await tester.pump();

          // Assert
          expect(find.byType(GoogleMap), findsNothing);
        },
      );
    },
  );

  group(
    'Marker Logic',
    () {
      final shoutOut1 = getValidShoutOut().copyWith(
        imageUrls: {},
      );
      final shoutOut2 = getValidShoutOut().copyWith(
        categories: {},
      );

      setUp(
        () {
          // Arrange
          when(mockBitmapIconLoader.loadAll()).thenAnswer(
            (_) async => defaultBitmapIcons,
          );
          final initializedState = initialMapControllerState.copyWith(
            initialized: true,
            coordinates: Coordinates(
              latitude: Latitude(0),
              longitude: Longitude(0),
            ),
            zoom: 15,
          );
          when(mockMapControllerBloc.state).thenReturn(initializedState);
          when(mockMapControllerBloc.stream).thenAnswer(
            (_) => Stream.value(initializedState),
          );
        },
      );

      testWidgets(
        'correctly maps ShoutOuts to Markers with custom icons',
        (tester) async {
          // Act
          await tester.pumpWidget(
            buildWidget(shoutOuts: {shoutOut1}),
          );
          await tester.pumpAndSettle();

          // Assert
          final googleMap = tester.widget<GoogleMap>(find.byType(GoogleMap));
          expect(googleMap.markers.length, 1);
          final marker = googleMap.markers.first;
          expect(marker.markerId, MarkerId(shoutOut1.id.getOrCrash()));
          expect(
            marker.position,
            LatLng(
              shoutOut1.coordinates.latitude.getOrCrash(),
              shoutOut1.coordinates.longitude.getOrCrash(),
            ),
          );
          expect(marker.infoWindow.title, shoutOut1.title.getOrCrash());
          expect(
            marker.infoWindow.snippet,
            shoutOut1.description.getOrCrash(),
          );
          expect(
            marker.icon,
            defaultBitmapIcons[shoutOut1.categories.first.name],
          );
        },
      );

      testWidgets(
        'uses default marker icon if category icon is not found '
            'or no categories',
        (tester) async {
          // Act
          await tester.pumpWidget(
            buildWidget(shoutOuts: {shoutOut2}),
          );
          await tester.pumpAndSettle();

          // Assert
          final googleMap = tester.widget<GoogleMap>(find.byType(GoogleMap));
          expect(googleMap.markers.length, 1);
          final marker = googleMap.markers.first;
          expect(marker.icon, BitmapDescriptor.defaultMarker);
        },
      );

      testWidgets(
        'shows ShoutOutModal on marker tap',
        (tester) async {
          // Act
          await tester.pumpWidget(
            buildWidget(shoutOuts: {shoutOut1}),
          );
          await tester.pumpAndSettle();

          final googleMap = tester.widget<GoogleMap>(find.byType(GoogleMap));
          final marker = googleMap.markers.first;

          expect(
            marker.onTap,
            isNotNull,
            reason: "Marker's onTap callback should be set.",
          );
          marker.onTap!();
          await tester.pump();

          // Assert
          final finder = find.byType(ShoutOutModal);
          expect(finder, findsOneWidget);
          expect(tester.widget<ShoutOutModal>(finder).shoutOut, shoutOut1);
        },
      );
    },
  );

  group(
    'Camera Move Logic',
    () {
      setUp(
        () {
          // Arrange
          when(mockBitmapIconLoader.loadAll()).thenAnswer(
            (_) async => defaultBitmapIcons,
          );
          final initializedState = initialMapControllerState.copyWith(
            initialized: true,
            coordinates: Coordinates(
              latitude: Latitude(0),
              longitude: Longitude(0),
            ),
            zoom: 15,
          );
          when(mockMapControllerBloc.state).thenReturn(initializedState);
          when(mockMapControllerBloc.stream).thenAnswer(
            (_) => Stream.value(initializedState),
          );
        },
      );

      testWidgets(
        'adds cameraPositionChanged event onCameraMove',
        (tester) async {
          // Arrange
          const newCameraPosition = CameraPosition(
            target: LatLng(10, 20),
            zoom: 12,
          );

          // Act
          await tester.pumpWidget(buildWidget(shoutOuts: const {}));
          await tester.pumpAndSettle();

          final googleMap = tester.widget<GoogleMap>(find.byType(GoogleMap));
          expect(
            googleMap.onCameraMove,
            isNotNull,
            reason: "GoogleMap's onCameraMove callback should be set.",
          );
          googleMap.onCameraMove!(newCameraPosition);
          await tester.pump();

          // Assert
          verify(
            mockMapControllerBloc.add(
              MapControllerEvent.cameraPositionChanged(
                coordinates: Coordinates(
                  latitude: Latitude(newCameraPosition.target.latitude),
                  longitude: Longitude(newCameraPosition.target.longitude),
                ),
                zoom: newCameraPosition.zoom,
              ),
            ),
          ).called(1);
        },
      );
    },
  );
}
