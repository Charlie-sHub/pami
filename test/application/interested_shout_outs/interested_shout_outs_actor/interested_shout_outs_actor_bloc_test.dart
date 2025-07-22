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
}
