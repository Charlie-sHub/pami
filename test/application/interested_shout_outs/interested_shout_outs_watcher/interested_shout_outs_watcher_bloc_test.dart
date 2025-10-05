import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_watcher/interested_shout_outs_watcher_bloc.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/interested_shout_outs/interested_shout_outs_repository_interface.dart';

import 'interested_shout_outs_watcher_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InterestedShoutOutsRepositoryInterface>()])
void main() {
  late MockInterestedShoutOutsRepositoryInterface mockRepository;
  late InterestedShoutOutsWatcherBloc interestedShoutOutsWatcherBloc;

  final validShoutOuts = <ShoutOut>[ShoutOut.empty()];
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockInterestedShoutOutsRepositoryInterface();
      interestedShoutOutsWatcherBloc = InterestedShoutOutsWatcherBloc(
        mockRepository,
      );
    },
  );

  tearDown(
    () => interestedShoutOutsWatcherBloc.close(),
  );

  group(
    'Testing on success',
    () {
      blocTest<InterestedShoutOutsWatcherBloc, InterestedShoutOutsWatcherState>(
        'emits [actionInProgress, loadSuccess] '
        'when watchStarted is added and repository returns Right',
        setUp: () {
          when(mockRepository.watchInterestedShoutOuts()).thenAnswer(
            (_) => Stream.value(
              right(validShoutOuts),
            ),
          );
        },
        build: () => interestedShoutOutsWatcherBloc,
        act: (bloc) => bloc.add(
          const InterestedShoutOutsWatcherEvent.watchStarted(),
        ),
        expect: () => [
          const InterestedShoutOutsWatcherState.actionInProgress(),
          InterestedShoutOutsWatcherState.loadSuccess(validShoutOuts),
        ],
        verify: (_) => verify(
          mockRepository.watchInterestedShoutOuts(),
        ).called(1),
      );

      blocTest<InterestedShoutOutsWatcherBloc, InterestedShoutOutsWatcherState>(
        'emits [loadSuccess] when resultsReceived '
        'is added and result is Right',
        build: () => interestedShoutOutsWatcherBloc,
        act: (bloc) => bloc.add(
          InterestedShoutOutsWatcherEvent.resultsReceived(
            right(validShoutOuts),
          ),
        ),
        expect: () => [
          InterestedShoutOutsWatcherState.loadSuccess(validShoutOuts),
        ],
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<InterestedShoutOutsWatcherBloc, InterestedShoutOutsWatcherState>(
        'emits [actionInProgress, loadFailure] '
        'when watchStarted is added and repository returns Left',
        setUp: () {
          when(mockRepository.watchInterestedShoutOuts()).thenAnswer(
            (_) => Stream.value(
              left(failure),
            ),
          );
        },
        build: () => interestedShoutOutsWatcherBloc,
        act: (bloc) => bloc.add(
          const InterestedShoutOutsWatcherEvent.watchStarted(),
        ),
        expect: () => [
          const InterestedShoutOutsWatcherState.actionInProgress(),
          const InterestedShoutOutsWatcherState.loadFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.watchInterestedShoutOuts(),
        ).called(1),
      );

      blocTest<InterestedShoutOutsWatcherBloc, InterestedShoutOutsWatcherState>(
        'emits [loadFailure] when resultsReceived '
        'is added and result is Left',
        build: () => interestedShoutOutsWatcherBloc,
        act: (bloc) => bloc.add(
          InterestedShoutOutsWatcherEvent.resultsReceived(left(failure)),
        ),
        expect: () => [
          const InterestedShoutOutsWatcherState.loadFailure(failure),
        ],
      );
    },
  );
}
