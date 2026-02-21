import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/profile/profile_watcher/profile_watcher_bloc.dart';
import 'package:pami/application/transactions/transaction_history_watcher/transaction_history_watcher_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/profile/widgets/profile_view.dart';

import 'profile_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ProfileWatcherBloc>(),
  MockSpec<TransactionHistoryWatcherBloc>(),
])
void main() {
  late MockProfileWatcherBloc mockProfileBloc;
  late MockTransactionHistoryWatcherBloc mockTransactionBloc;

  setUp(
    () async {
      mockProfileBloc = MockProfileWatcherBloc();
      mockTransactionBloc = MockTransactionHistoryWatcherBloc();

      getIt
        ..registerFactory<TransactionHistoryWatcherBloc>(
          () => mockTransactionBloc,
        )
        ..registerFactory<ProfileWatcherBloc>(
          () => mockProfileBloc,
        );

      provideDummy<ProfileWatcherState>(
        const ProfileWatcherState.initial(),
      );
      provideDummy<TransactionHistoryWatcherState>(
        const TransactionHistoryWatcherState.initial(),
      );
    },
  );

  tearDown(() async => getIt.reset());

  Widget build() => const MaterialApp(
    home: Scaffold(
      body: ProfileView(),
    ),
  );

  testWidgets(
    'shows loading when state is loadInProgress',
    (tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(
        const ProfileWatcherState.loadInProgress(),
      );

      // Act
      await tester.pumpWidget(build());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'shows ProfileContent when loadSuccess',
    (tester) async {
      // Arrange
      final user = getValidUser().copyWith(
        avatar: Url(''),
      );
      when(mockProfileBloc.state).thenReturn(
        ProfileWatcherState.loadSuccess(user),
      );

      // Act
      await tester.pumpWidget(build());

      // Assert
      expect(find.text(user.name.getOrCrash()), findsOneWidget);
    },
  );

  testWidgets(
    'shows error text when loadFailure',
    (tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(
        const ProfileWatcherState.loadFailure(
          AppFailure.serverError(errorString: 'errorString'),
        ),
      );

      // Act
      await tester.pumpWidget(build());

      // Assert
      expect(find.textContaining('Failed to load profile'), findsOneWidget);
    },
  );
}
