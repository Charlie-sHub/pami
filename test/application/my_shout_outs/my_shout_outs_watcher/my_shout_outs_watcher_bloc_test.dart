import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/my_shout_outs/my_shout_outs_watcher/my_shout_outs_watcher_bloc.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/my_shout_outs/my_shout_outs_repository_interface.dart';

import 'my_shout_outs_watcher_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MyShoutOutsRepositoryInterface>()])
void main() {
  late MockMyShoutOutsRepositoryInterface mockRepository;
  late MyShoutOutsWatcherBloc myShoutOutsWatcherBloc;

  final validShoutOuts = <ShoutOut>{ShoutOut.empty()};
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockMyShoutOutsRepositoryInterface();
      myShoutOutsWatcherBloc = MyShoutOutsWatcherBloc(mockRepository);
    },
  );

  tearDown(
    () => myShoutOutsWatcherBloc.close(),
  );

  group(
    'Testing on success',
    () {
      blocTest<MyShoutOutsWatcherBloc, MyShoutOutsWatcherState>(
        'emits [actionInProgress, loadSuccess] '
        'when watchStarted is added and repository returns Right',
        setUp: () {
          when(mockRepository.watchMyShoutOuts()).thenAnswer(
            (_) => Stream.value(
              right(validShoutOuts),
            ),
          );
        },
        build: () => myShoutOutsWatcherBloc,
        act: (bloc) => bloc.add(
          const MyShoutOutsWatcherEvent.watchStarted(),
        ),
        expect: () => [
          const MyShoutOutsWatcherState.actionInProgress(),
          MyShoutOutsWatcherState.loadSuccess(validShoutOuts),
        ],
        verify: (_) => verify(
          mockRepository.watchMyShoutOuts(),
        ).called(1),
      );

      blocTest<MyShoutOutsWatcherBloc, MyShoutOutsWatcherState>(
        'emits [loadSuccess] when resultsReceived '
        'is added and result is Right',
        build: () => myShoutOutsWatcherBloc,
        act: (bloc) => bloc.add(
          MyShoutOutsWatcherEvent.resultsReceived(right(validShoutOuts)),
        ),
        expect: () => [
          MyShoutOutsWatcherState.loadSuccess(validShoutOuts),
        ],
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<MyShoutOutsWatcherBloc, MyShoutOutsWatcherState>(
        'emits [actionInProgress, loadFailure] '
        'when watchStarted is added and repository returns Left',
        setUp: () {
          when(mockRepository.watchMyShoutOuts()).thenAnswer(
            (_) => Stream.value(
              left(failure),
            ),
          );
        },
        build: () => myShoutOutsWatcherBloc,
        act: (bloc) => bloc.add(
          const MyShoutOutsWatcherEvent.watchStarted(),
        ),
        expect: () => [
          const MyShoutOutsWatcherState.actionInProgress(),
          const MyShoutOutsWatcherState.loadFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.watchMyShoutOuts(),
        ).called(1),
      );

      blocTest<MyShoutOutsWatcherBloc, MyShoutOutsWatcherState>(
        'emits [loadFailure] when resultsReceived '
        'is added and result is Left',
        build: () => myShoutOutsWatcherBloc,
        act: (bloc) => bloc.add(
          MyShoutOutsWatcherEvent.resultsReceived(left(failure)),
        ),
        expect: () => [
          const MyShoutOutsWatcherState.loadFailure(failure),
        ],
      );
    },
  );
}
