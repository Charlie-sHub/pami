import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/transactions/transaction_history_watcher/transaction_history_watcher_bloc.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/failures/app_failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/transactions/transaction_repository_interface.dart';

import 'transaction_history_watcher_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TransactionRepositoryInterface>()])
void main() {
  late MockTransactionRepositoryInterface repository;
  late TransactionHistoryWatcherBloc bloc;

  final userId = UniqueId();

  setUp(
    () {
      repository = MockTransactionRepositoryInterface();
      bloc = TransactionHistoryWatcherBloc(repository);
    },
  );

  tearDown(
    () => bloc.close(),
  );

  blocTest<TransactionHistoryWatcherBloc, TransactionHistoryWatcherState>(
    'emits loadInProgress -> loadSuccess when repository returns transactions',
    build: () {
      when(
        repository.fetchUserTransactions(userId),
      ).thenAnswer((_) async => right(<Transaction>[]));
      return bloc;
    },
    act: (bloc) => bloc.add(
      TransactionHistoryWatcherEvent.fetchTransactionHistory(userId),
    ),
    expect: () => [
      const TransactionHistoryWatcherState.loadInProgress(),
      const TransactionHistoryWatcherState.loadSuccess(<Transaction>[]),
    ],
    verify: (_) {
      verify(repository.fetchUserTransactions(userId)).called(1);
    },
  );

  blocTest<TransactionHistoryWatcherBloc, TransactionHistoryWatcherState>(
    'emits loadInProgress -> loadFailure when repository fails',
    build: () {
      when(repository.fetchUserTransactions(userId)).thenAnswer(
        (_) async =>
            left(const AppFailure.serverError(errorString: 'errorString')),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(
      TransactionHistoryWatcherEvent.fetchTransactionHistory(userId),
    ),
    expect: () => [
      const TransactionHistoryWatcherState.loadInProgress(),
      const TransactionHistoryWatcherState.loadFailure(
        AppFailure.serverError(errorString: 'errorString'),
      ),
    ],
  );
}
