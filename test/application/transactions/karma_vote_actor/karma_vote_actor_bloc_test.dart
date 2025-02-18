import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/transactions/karma_vote_actor/karma_vote_actor_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/transactions/transaction_repository_interface.dart';

import 'karma_vote_actor_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TransactionRepositoryInterface>()])
void main() {
  late MockTransactionRepositoryInterface mockRepository;
  late KarmaVoteActorBloc karmaVoteActorBloc;

  final validTransactionId = UniqueId();
  const isPositive = true;
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockTransactionRepositoryInterface();
      karmaVoteActorBloc = KarmaVoteActorBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<KarmaVoteActorBloc, KarmaVoteActorState>(
        'emits [actionInProgress, voteSuccess] when voteSubmitted '
        'is added and repository returns Right',
        setUp: () {
          when(
            mockRepository.submitKarmaVote(
              shoutOutId: anyNamed('shoutOutId'),
              vote: anyNamed('vote'),
            ),
          ).thenAnswer((_) async => right(unit));
        },
        build: () => karmaVoteActorBloc,
        act: (bloc) => bloc.add(
          KarmaVoteActorEvent.voteSubmitted(
            shoutOutId: validTransactionId,
            isPositive: isPositive,
          ),
        ),
        expect: () => [
          const KarmaVoteActorState.actionInProgress(),
          const KarmaVoteActorState.voteSuccess(),
        ],
        verify: (_) => verify(
          mockRepository.submitKarmaVote(
            shoutOutId: validTransactionId,
            vote: isPositive,
          ),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<KarmaVoteActorBloc, KarmaVoteActorState>(
        'emits [actionInProgress, voteFailure] when voteSubmitted '
        'is added and repository returns Left',
        setUp: () {
          when(
            mockRepository.submitKarmaVote(
              shoutOutId: anyNamed('shoutOutId'),
              vote: anyNamed('vote'),
            ),
          ).thenAnswer((_) async => left(failure));
        },
        build: () => karmaVoteActorBloc,
        act: (bloc) => bloc.add(
          KarmaVoteActorEvent.voteSubmitted(
            shoutOutId: validTransactionId,
            isPositive: isPositive,
          ),
        ),
        expect: () => [
          const KarmaVoteActorState.actionInProgress(),
          const KarmaVoteActorState.voteFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.submitKarmaVote(
            shoutOutId: validTransactionId,
            vote: isPositive,
          ),
        ).called(1),
      );
    },
  );
}
