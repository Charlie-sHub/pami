import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/transactions/transaction_listener/transaction_listener_bloc.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/transactions/transaction_repository_interface.dart';

import 'transaction_listener_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TransactionRepositoryInterface>()])
void main() {
  late MockTransactionRepositoryInterface mockRepository;
  late TransactionListenerBloc transactionListenerBloc;

  final validShoutOutId = UniqueId();
  final validTransaction = Transaction.empty();
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockTransactionRepositoryInterface();
      transactionListenerBloc = TransactionListenerBloc(mockRepository);
    },
  );

  tearDown(
    () => transactionListenerBloc.close(),
  );

  group(
    'Testing on success',
    () {
      blocTest<TransactionListenerBloc, TransactionListenerState>(
        'emits [loadInProgress, loadSuccess] when listenShoutOutStarted '
        'is added and repository returns Right',
        setUp: () {
          when(mockRepository.watchShoutOutForTransaction(any)).thenAnswer(
            (_) => Stream.value(
              right(validTransaction),
            ),
          );
        },
        build: () => transactionListenerBloc,
        act: (bloc) => bloc.add(
          TransactionListenerEvent.listenShoutOutStarted(validShoutOutId),
        ),
        expect: () => [
          const TransactionListenerState.loadInProgress(),
          TransactionListenerState.loadSuccess(validTransaction),
        ],
        verify: (_) => verify(
          mockRepository.watchShoutOutForTransaction(validShoutOutId),
        ).called(1),
      );

      blocTest<TransactionListenerBloc, TransactionListenerState>(
        'emits [loadSuccess] when shoutOutUpdated is added and result is Right',
        build: () => transactionListenerBloc,
        act: (bloc) => bloc.add(
          TransactionListenerEvent.shoutOutUpdated(right(validTransaction)),
        ),
        expect: () => [
          TransactionListenerState.loadSuccess(validTransaction),
        ],
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<TransactionListenerBloc, TransactionListenerState>(
        'emits [loadInProgress, loadFailure] when '
        'listenShoutOutStarted is added and repository returns Left',
        setUp: () {
          when(mockRepository.watchShoutOutForTransaction(any)).thenAnswer(
            (_) => Stream.value(
              left(failure),
            ),
          );
        },
        build: () => transactionListenerBloc,
        act: (bloc) => bloc.add(
          TransactionListenerEvent.listenShoutOutStarted(validShoutOutId),
        ),
        expect: () => [
          const TransactionListenerState.loadInProgress(),
          const TransactionListenerState.loadFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.watchShoutOutForTransaction(validShoutOutId),
        ).called(1),
      );

      blocTest<TransactionListenerBloc, TransactionListenerState>(
        'emits [loadFailure] when shoutOutUpdated is added and result is Left',
        build: () => transactionListenerBloc,
        act: (bloc) => bloc.add(
          TransactionListenerEvent.shoutOutUpdated(left(failure)),
        ),
        expect: () => [
          const TransactionListenerState.loadFailure(failure),
        ],
      );
    },
  );
}
