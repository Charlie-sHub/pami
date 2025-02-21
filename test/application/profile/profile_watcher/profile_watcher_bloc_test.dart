import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/profile/profile_watcher/profile_watcher_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/profile/profile_repository_interface.dart';

import '../../../misc/get_valid_user.dart';
import 'profile_watcher_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileRepositoryInterface>()])
void main() {
  late MockProfileRepositoryInterface mockRepository;
  late ProfileWatcherBloc profileWatcherBloc;

  final validUser = getValidUser();
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockProfileRepositoryInterface();
      profileWatcherBloc = ProfileWatcherBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<ProfileWatcherBloc, ProfileWatcherState>(
        'emits [loadInProgress, loadSuccess] when fetchProfile is '
        'added and repository returns Right',
        setUp: () {
          when(mockRepository.getCurrentUser()).thenAnswer(
            (_) async => right(validUser),
          );
        },
        build: () => profileWatcherBloc,
        act: (bloc) => bloc.add(
          const ProfileWatcherEvent.fetchProfile(),
        ),
        expect: () => [
          const ProfileWatcherState.loadInProgress(),
          ProfileWatcherState.loadSuccess(validUser),
        ],
        verify: (_) => verify(
          mockRepository.getCurrentUser(),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<ProfileWatcherBloc, ProfileWatcherState>(
        'emits [loadInProgress, loadFailure] when fetchProfile is '
        'added and repository returns Left',
        setUp: () {
          when(mockRepository.getCurrentUser()).thenAnswer(
            (_) async => left(failure),
          );
        },
        build: () => profileWatcherBloc,
        act: (bloc) => bloc.add(
          const ProfileWatcherEvent.fetchProfile(),
        ),
        expect: () => [
          const ProfileWatcherState.loadInProgress(),
          const ProfileWatcherState.loadFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.getCurrentUser(),
        ).called(1),
      );
    },
  );
}
