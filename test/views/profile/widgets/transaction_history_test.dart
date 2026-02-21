import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/transactions/transaction_history_watcher/transaction_history_watcher_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/profile/widgets/transaction_history.dart';

import 'transaction_history_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TransactionHistoryWatcherBloc>(),
])
void main() {
  late MockTransactionHistoryWatcherBloc mockBloc;
  late UniqueId userId;

  setUp(
    () {
      userId = UniqueId();
      mockBloc = MockTransactionHistoryWatcherBloc();

      getIt.registerFactory<TransactionHistoryWatcherBloc>(() => mockBloc);

      provideDummy<TransactionHistoryWatcherState>(
        const TransactionHistoryWatcherState.initial(),
      );
    },
  );

  tearDown(() async => getIt.reset());

  Widget build() => MaterialApp(
    home: Scaffold(
      body: BlocProvider<TransactionHistoryWatcherBloc>.value(
        value: mockBloc,
        child: TransactionHistory(userId: userId),
      ),
    ),
  );

  testWidgets(
    'shows "No transactions yet." when state is loadSuccess([])',
    (
      tester,
    ) async {
      when(mockBloc.state).thenReturn(
        const TransactionHistoryWatcherState.loadSuccess([]),
      );

      await tester.pumpWidget(build());
      await tester.pump();

      expect(find.text('No transactions yet.'), findsOneWidget);
    },
  );

  testWidgets(
    'shows CircularProgressIndicator when state is loadInProgress',
    (
      tester,
    ) async {
      when(mockBloc.state).thenReturn(
        const TransactionHistoryWatcherState.loadInProgress(),
      );

      await tester.pumpWidget(build());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'shows failure text when state is loadFailure',
    (tester) async {
      const failure = AppFailure.serverError(errorString: 'test');
      when(mockBloc.state).thenReturn(
        const TransactionHistoryWatcherState.loadFailure(failure),
      );

      await tester.pumpWidget(build());
      await tester.pump();

      expect(
        find.text('Failed to load transactions: $failure'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'shows a list of transaction cards when state is loadSuccess with data',
    (tester) async {
      // Arrange
      final transaction = getValidTransaction();

      when(mockBloc.state).thenReturn(
        TransactionHistoryWatcherState.loadSuccess([transaction]),
      );

      await tester.pumpWidget(build());
      await tester.pump();

      final title = transaction.shoutOutTitle.value.fold(
        (_) => '',
        (value) => value,
      );

      // Assert
      expect(find.text(title), findsOneWidget);
    },
  );
}
