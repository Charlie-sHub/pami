import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/map/map_controller/map_controller_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';
import 'package:pami/domain/map/map_repository_interface.dart';

import 'map_controller_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MapRepositoryInterface>(),
])
void main() {
  late MapControllerBloc mapControllerBloc;
  late MockMapRepositoryInterface mockMapRepository;

  final validCoordinates = getValidCoordinates();
  const validZoom = 14.0;
  final newCoordinates = validCoordinates.copyWith(
    longitude: Longitude(90),
  );

  setUp(
    () {
      TestWidgetsFlutterBinding.ensureInitialized();
      mockMapRepository = MockMapRepositoryInterface();
      mapControllerBloc = MapControllerBloc(
        mockMapRepository
      );
    },
  );

  tearDown(
    () => mapControllerBloc.close(),
  );

  group(
    'Testing on success',
    () {
      blocTest<MapControllerBloc, MapControllerState>(
        'emits state with initial coordinates and zoom '
        'when Initialized is added',
        setUp: () {
          when(mockMapRepository.getCurrentLocation()).thenAnswer(
            (_) async => Right(validCoordinates),
          );
        },
        build: () => mapControllerBloc,
        act: (bloc) => bloc.add(
          const MapControllerEvent.initialized(),
        ),
        expect: () => [
          MapControllerState.initial().copyWith(
            coordinates: validCoordinates,
            initialized: true,
          ),
        ],
      );

      blocTest<MapControllerBloc, MapControllerState>(
        'streams updates when Initialized is added',
        setUp: () {
          when(mockMapRepository.getCurrentLocation()).thenAnswer(
            (_) async => Right(validCoordinates),
          );
          when(mockMapRepository.getUserLocationStream()).thenAnswer(
            (_) => Stream.fromIterable(
              [Right(newCoordinates)],
            ),
          );
        },
        build: () => mapControllerBloc,
        act: (bloc) => bloc.add(
          const MapControllerEvent.initialized(),
        ),
        expect: () => [
          MapControllerState.initial().copyWith(
            coordinates: validCoordinates,
            initialized: true,
          ),
          MapControllerState.initial().copyWith(
            coordinates: newCoordinates,
            initialized: true,
          ),
        ],
      );

      blocTest<MapControllerBloc, MapControllerState>(
        'emits state with changed coordinates and zoom '
        'when CameraPositionChanged is added',
        build: () => mapControllerBloc,
        act: (bloc) => bloc.add(
          MapControllerEvent.cameraPositionChanged(
            coordinates: newCoordinates,
            zoom: validZoom,
          ),
        ),
        expect: () => [
          MapControllerState.initial().copyWith(
            coordinates: newCoordinates,
            zoom: validZoom,
          ),
        ],
      );

      blocTest<MapControllerBloc, MapControllerState>(
        'emits state with changed coordinates '
        'when UserLocationUpdated with coordinates is added',
        build: () => mapControllerBloc,
        act: (bloc) => bloc.add(
          MapControllerEvent.userLocationUpdated(
            result: Right(newCoordinates),
          ),
        ),
        expect: () => [
          MapControllerState.initial().copyWith(
            coordinates: newCoordinates,
          ),
        ],
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<MapControllerBloc, MapControllerState>(
        'emits the same state when getCurrentLocation fails',
        setUp: () {
          when(mockMapRepository.getCurrentLocation()).thenAnswer(
            (_) async => const Left(Failure.serverError(errorString: 'test')),
          );
        },
        build: () => mapControllerBloc,
        act: (bloc) => bloc.add(const MapControllerEvent.initialized()),
        expect: () => [MapControllerState.initial()],
      );

      blocTest<MapControllerBloc, MapControllerState>(
        'stream updates does nothing when stream fails',
        setUp: () {
          when(mockMapRepository.getCurrentLocation()).thenAnswer(
            (_) async => Right(validCoordinates),
          );
          when(mockMapRepository.getUserLocationStream()).thenAnswer(
            (_) => Stream.fromIterable(
              [const Left(Failure.serverError(errorString: 'test'))],
            ),
          );
        },
        build: () => mapControllerBloc,
        act: (bloc) => bloc.add(const MapControllerEvent.initialized()),
        expect: () => [
          MapControllerState.initial().copyWith(
            coordinates: validCoordinates,
            initialized: true,
          ),
        ],
      );

      blocTest<MapControllerBloc, MapControllerState>(
        'emits no changes when UserLocationUpdated with failure is added',
        build: () => mapControllerBloc,
        act: (bloc) => bloc.add(
          const MapControllerEvent.userLocationUpdated(
            result: Left(Failure.serverError(errorString: 'test')),
          ),
        ),
        expect: () => [MapControllerState.initial()],
      );
    },
  );
}
