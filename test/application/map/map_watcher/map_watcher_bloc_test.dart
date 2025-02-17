import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/map/map_watcher/map_watcher_bloc.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/map/map_repository_interface.dart';

import 'map_watcher_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MapRepositoryInterface>()])
void main() {
  late MockMapRepositoryInterface mockMapRepository;
  late MapWatcherBloc mapWatcherBloc;

  final validSettings = MapSettings.empty();
  final validShoutOuts = {ShoutOut.empty()};
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockMapRepository = MockMapRepositoryInterface();
      mapWatcherBloc = MapWatcherBloc(mockMapRepository);
    },
  );

  tearDown(
    () => mapWatcherBloc.close(),
  );

  group(
    'Testing on success',
    () {
      blocTest<MapWatcherBloc, MapWatcherState>(
        'emits [actionInProgress, loadSuccess] when watchStarted '
        'is added and repository returns Right',
        setUp: () {
          when(mockMapRepository.watchShoutOuts(any)).thenAnswer(
            (_) => Stream.value(right(validShoutOuts)),
          );
        },
        build: () => mapWatcherBloc,
        act: (bloc) => bloc.add(
          MapWatcherEvent.watchStarted(validSettings),
        ),
        expect: () => [
          const MapWatcherState.actionInProgress(),
          MapWatcherState.loadSuccess(validShoutOuts),
        ],
        verify: (_) => verify(
          mockMapRepository.watchShoutOuts(validSettings),
        ).called(1),
      );

      blocTest<MapWatcherBloc, MapWatcherState>(
        'emits [loadSuccess] when resultsReceived is added and result is Right',
        build: () => mapWatcherBloc,
        act: (bloc) => bloc.add(
          MapWatcherEvent.resultsReceived(right(validShoutOuts)),
        ),
        expect: () => [
          MapWatcherState.loadSuccess(validShoutOuts),
        ],
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<MapWatcherBloc, MapWatcherState>(
        'emits [actionInProgress, loadFailure] when watchStarted '
        'is added and repository returns Left',
        setUp: () {
          when(mockMapRepository.watchShoutOuts(any)).thenAnswer(
            (_) => Stream.value(
              left(failure),
            ),
          );
        },
        build: () => mapWatcherBloc,
        act: (bloc) => bloc.add(
          MapWatcherEvent.watchStarted(validSettings),
        ),
        expect: () => [
          const MapWatcherState.actionInProgress(),
          const MapWatcherState.loadFailure(failure),
        ],
        verify: (_) => verify(
          mockMapRepository.watchShoutOuts(validSettings),
        ).called(1),
      );

      blocTest<MapWatcherBloc, MapWatcherState>(
        'emits [loadFailure] when resultsReceived is added and result is Left',
        build: () => mapWatcherBloc,
        act: (bloc) => bloc.add(
          MapWatcherEvent.resultsReceived(left(failure)),
        ),
        expect: () => [
          const MapWatcherState.loadFailure(failure),
        ],
      );
    },
  );
}
