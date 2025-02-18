import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/transactions/transaction_actor_bloc/transaction_actor_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/transactions/transaction_repository_interface.dart';

import 'transaction_actor_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TransactionRepositoryInterface>()])
void main() {
  late MockTransactionRepositoryInterface mockRepository;
  late TransactionActorBloc transactionActorBloc;

  final validShoutOutId = UniqueId();
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockTransactionRepositoryInterface();
      transactionActorBloc = TransactionActorBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<TransactionActorBloc, TransactionActorState>(
        'emits [actionInProgress, transactionSuccess] when '
        'transactionCreated is added and repository returns Right',
        setUp: () {
          when(mockRepository.createTransaction(any)).thenAnswer(
            (_) async => right(unit),
          );
        },
        build: () => transactionActorBloc,
        act: (bloc) => bloc.add(
          TransactionActorEvent.transactionCreated(shoutOutId: validShoutOutId),
        ),
        expect: () => [
          const TransactionActorState.actionInProgress(),
          TransactionActorState.transactionSuccess(validShoutOutId),
        ],
        verify: (_) => verify(
          mockRepository.createTransaction(validShoutOutId),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<TransactionActorBloc, TransactionActorState>(
        'emits [actionInProgress, transactionFailure] when '
        'transactionCreated is added and repository returns Left',
        setUp: () {
          when(mockRepository.createTransaction(any)).thenAnswer(
            (_) async => left(failure),
          );
        },
        build: () => transactionActorBloc,
        act: (bloc) => bloc.add(
          TransactionActorEvent.transactionCreated(shoutOutId: validShoutOutId),
        ),
        expect: () => [
          const TransactionActorState.actionInProgress(),
          const TransactionActorState.transactionFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.createTransaction(validShoutOutId),
        ).called(1),
      );
    },
  );
}
