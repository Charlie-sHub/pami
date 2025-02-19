import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/profile/user_deletion_actor/user_deletion_actor_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/profile/profile_repository_interface.dart';

import 'user_deletion_actor_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileRepositoryInterface>()])
void main() {
  late MockProfileRepositoryInterface mockRepository;
  late UserDeletionActorBloc userDeletionActorBloc;

  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockProfileRepositoryInterface();
      userDeletionActorBloc = UserDeletionActorBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<UserDeletionActorBloc, UserDeletionActorState>(
        'emits [actionInProgress, deletionSuccess] when '
        'deletionRequested is added and repository returns Right',
        setUp: () {
          when(mockRepository.deleteUser()).thenAnswer(
            (_) async => right(unit),
          );
        },
        build: () => userDeletionActorBloc,
        act: (bloc) => bloc.add(
          const UserDeletionActorEvent.deleteRequested(),
        ),
        expect: () => [
          const UserDeletionActorState.actionInProgress(),
          const UserDeletionActorState.deletionSuccess(),
        ],
        verify: (_) => verify(
          mockRepository.deleteUser(),
        ).called(1),
      );
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<UserDeletionActorBloc, UserDeletionActorState>(
        'emits [actionInProgress, deletionFailure] when '
        'deletionRequested is added and repository returns Left',
        setUp: () {
          when(mockRepository.deleteUser())
              .thenAnswer((_) async => left(failure));
        },
        build: () => userDeletionActorBloc,
        act: (bloc) => bloc.add(
          const UserDeletionActorEvent.deleteRequested(),
        ),
        expect: () => [
          const UserDeletionActorState.actionInProgress(),
          const UserDeletionActorState.deletionFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.deleteUser(),
        ).called(1),
      );
    },
  );
}
