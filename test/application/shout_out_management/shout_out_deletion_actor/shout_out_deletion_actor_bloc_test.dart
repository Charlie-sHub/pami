import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/shout_out_management/shout_out_deletion_actor/shout_out_deletion_actor_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/shout_out_management/shout_out_management_repository_interface.dart';

import 'shout_out_deletion_actor_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ShoutOutManagementRepositoryInterface>()])
void main() {
  late MockShoutOutManagementRepositoryInterface mockRepository;
  late ShoutOutDeletionActorBloc shoutOutDeletionActorBloc;

  final validShoutOutId = UniqueId();
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockShoutOutManagementRepositoryInterface();
      shoutOutDeletionActorBloc = ShoutOutDeletionActorBloc(mockRepository);
    },
  );

  blocTest<ShoutOutDeletionActorBloc, ShoutOutDeletionActorState>(
    'emits [actionInProgress, deletionSuccess] '
    'when deleteRequested is added and repository returns Right',
    setUp: () {
      when(mockRepository.deleteShoutOut(any)).thenAnswer(
        (_) async => right(unit),
      );
    },
    build: () => shoutOutDeletionActorBloc,
    act: (bloc) => bloc.add(
      ShoutOutDeletionActorEvent.deleteRequested(validShoutOutId),
    ),
    expect: () => [
      const ShoutOutDeletionActorState.actionInProgress(),
      const ShoutOutDeletionActorState.deletionSuccess(),
    ],
    verify: (_) => verify(
      mockRepository.deleteShoutOut(validShoutOutId),
    ).called(1),
  );

  blocTest<ShoutOutDeletionActorBloc, ShoutOutDeletionActorState>(
    'emits [actionInProgress, deletionFailure] '
    'when deleteRequested is added and repository returns Left',
    setUp: () {
      when(mockRepository.deleteShoutOut(any)).thenAnswer(
        (_) async => left(failure),
      );
    },
    build: () => shoutOutDeletionActorBloc,
    act: (bloc) => bloc.add(
      ShoutOutDeletionActorEvent.deleteRequested(validShoutOutId),
    ),
    expect: () => [
      const ShoutOutDeletionActorState.actionInProgress(),
      const ShoutOutDeletionActorState.deletionFailure(failure),
    ],
    verify: (_) => verify(
      mockRepository.deleteShoutOut(validShoutOutId),
    ).called(1),
  );
}
