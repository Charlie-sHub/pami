import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/interested_shout_outs/interested_shout_outs_repository_interface.dart';

import 'interested_shout_outs_actor_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InterestedShoutOutsRepositoryInterface>(),
])
void main() {
  late MockInterestedShoutOutsRepositoryInterface mockRepository;
  late InterestedShoutOutsActorBloc interestedShoutOutsActorBloc;

  final shoutOutId = UniqueId();
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockInterestedShoutOutsRepositoryInterface();
      interestedShoutOutsActorBloc = InterestedShoutOutsActorBloc(
        mockRepository,
      );
    },
  );

  tearDown(
    () => interestedShoutOutsActorBloc.close(),
  );

  group(
    'Testing on success',
    () {
      blocTest<InterestedShoutOutsActorBloc, InterestedShoutOutsActorState>(
        'emits [actionInProgress, additionSuccess] '
        'when addInterestedShoutOut returns Right',
        setUp: () {
          when(mockRepository.addInterestedShoutOut(shoutOutId)).thenAnswer(
            (_) async => const Right(unit),
          );
        },
        build: () => interestedShoutOutsActorBloc,
        act: (bloc) => bloc.add(
          InterestedShoutOutsActorEvent.addToInterested(
            shoutOutId: shoutOutId,
          ),
        ),
        expect: () => [
          const InterestedShoutOutsActorState.actionInProgress(),
          const InterestedShoutOutsActorState.additionSuccess(),
        ],
        verify: (_) => verify(
          mockRepository.addInterestedShoutOut(shoutOutId),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<InterestedShoutOutsActorBloc, InterestedShoutOutsActorState>(
        'emits [actionInProgress, additionFailure] '
        'when addInterestedShoutOut returns Left',
        setUp: () {
          when(mockRepository.addInterestedShoutOut(shoutOutId)).thenAnswer(
            (_) async => const Left(failure),
          );
        },
        build: () => interestedShoutOutsActorBloc,
        act: (bloc) => bloc.add(
          InterestedShoutOutsActorEvent.addToInterested(
            shoutOutId: shoutOutId,
          ),
        ),
        expect: () => [
          const InterestedShoutOutsActorState.actionInProgress(),
          const InterestedShoutOutsActorState.additionFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.addInterestedShoutOut(shoutOutId),
        ).called(1),
      );
    },
  );

  group(
    'Testing dismiss from interested',
    () {
      blocTest<InterestedShoutOutsActorBloc, InterestedShoutOutsActorState>(
        'emits [actionInProgress, dismissalSuccess] when '
        'dismissInterestedShoutOut returns Right',
        setUp: () {
          when(mockRepository.dismissInterestedShoutOut(shoutOutId)).thenAnswer(
            (_) async => const Right(unit),
          );
        },
        build: () => interestedShoutOutsActorBloc,
        act: (bloc) => bloc.add(
          InterestedShoutOutsActorEvent.dismissFromInterested(
            shoutOutId: shoutOutId,
          ),
        ),
        expect: () => [
          const InterestedShoutOutsActorState.actionInProgress(),
          const InterestedShoutOutsActorState.dismissalSuccess(),
        ],
        verify: (_) => verify(
          mockRepository.dismissInterestedShoutOut(shoutOutId),
        ).called(1),
      );

      blocTest<InterestedShoutOutsActorBloc, InterestedShoutOutsActorState>(
        'emits [actionInProgress, dismissalFailure] '
        'when dismissInterestedShoutOut returns Left',
        setUp: () {
          when(mockRepository.dismissInterestedShoutOut(shoutOutId)).thenAnswer(
            (_) async => const Left(failure),
          );
        },
        build: () => interestedShoutOutsActorBloc,
        act: (bloc) => bloc.add(
          InterestedShoutOutsActorEvent.dismissFromInterested(
            shoutOutId: shoutOutId,
          ),
        ),
        expect: () => [
          const InterestedShoutOutsActorState.actionInProgress(),
          const InterestedShoutOutsActorState.dismissalFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.dismissInterestedShoutOut(shoutOutId),
        ).called(1),
      );
    },
  );

  group(
    'Testing scan confirmation',
    () {
      blocTest<InterestedShoutOutsActorBloc, InterestedShoutOutsActorState>(
        'emits [actionInProgress, scanSuccess] '
        'when payload matches and repo returns Right',
        setUp: () {
          when(
            mockRepository.confirmScan(
              shoutOutId: anyNamed('shoutOutId'),
              scannerUserId: anyNamed('scannerUserId'),
              rawPayload: anyNamed('rawPayload'),
            ),
          ).thenAnswer((_) async => const Right(unit));
        },
        build: () => interestedShoutOutsActorBloc,
        act: (bloc) => bloc.add(
          InterestedShoutOutsActorEvent.scanCompleted(
            shoutOutId: shoutOutId,
            payload: shoutOutId.getOrCrash(),
          ),
        ),
        expect: () => [
          const InterestedShoutOutsActorState.actionInProgress(),
          const InterestedShoutOutsActorState.scanSuccess(),
        ],
        verify: (_) => verify(
          mockRepository.confirmScan(
            shoutOutId: shoutOutId,
            scannerUserId: anyNamed('scannerUserId'),
            rawPayload: anyNamed('rawPayload'),
          ),
        ).called(1),
      );

      blocTest<InterestedShoutOutsActorBloc, InterestedShoutOutsActorState>(
        'emits [actionInProgress, scanFailure(invalidQr)] '
        'when payload does not match',
        build: () => interestedShoutOutsActorBloc,
        act: (bloc) => bloc.add(
          InterestedShoutOutsActorEvent.scanCompleted(
            shoutOutId: UniqueId.fromUniqueString(
              '11111111-1111-1111-1111-111111111111',
            ),
            payload: 'wrong-payload',
          ),
        ),
        expect: () => [
          const InterestedShoutOutsActorState.actionInProgress(),
          const InterestedShoutOutsActorState.scanFailure(
            Failure.invalidQr(failedValue: 'wrong-payload'),
          ),
        ],
        verify: (_) => verifyNever(
          mockRepository.confirmScan(
            shoutOutId: anyNamed('shoutOutId'),
            scannerUserId: anyNamed('scannerUserId'),
            rawPayload: anyNamed('rawPayload'),
          ),
        ),
      );

      blocTest<InterestedShoutOutsActorBloc, InterestedShoutOutsActorState>(
        'emits [actionInProgress, scanFailure(serverError)] '
        'when repo returns Left',
        setUp: () {
          when(
            mockRepository.confirmScan(
              shoutOutId: anyNamed('shoutOutId'),
              scannerUserId: anyNamed('scannerUserId'),
              rawPayload: anyNamed('rawPayload'),
            ),
          ).thenAnswer((_) async => const Left(failure));
        },
        build: () => interestedShoutOutsActorBloc,
        act: (bloc) => bloc.add(
          InterestedShoutOutsActorEvent.scanCompleted(
            shoutOutId: shoutOutId,
            payload: shoutOutId.getOrCrash(),
          ),
        ),
        expect: () => [
          const InterestedShoutOutsActorState.actionInProgress(),
          const InterestedShoutOutsActorState.scanFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.confirmScan(
            shoutOutId: shoutOutId,
            scannerUserId: anyNamed('scannerUserId'),
            rawPayload: anyNamed('rawPayload'),
          ),
        ).called(1),
      );
    },
  );
}
