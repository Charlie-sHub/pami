import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/transactions/transaction_history_watcher/transaction_history_watcher_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/profile/widgets/profile_content.dart';

import 'profile_content_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TransactionHistoryWatcherBloc>(),
])
void main() {
  late MockTransactionHistoryWatcherBloc mockBloc;

  final user = getValidUser().copyWith(
    avatar: Url(''),
  );

  setUp(
    () async {
      mockBloc = MockTransactionHistoryWatcherBloc();

      getIt.registerFactory<TransactionHistoryWatcherBloc>(() => mockBloc);

      provideDummy<TransactionHistoryWatcherState>(
        const TransactionHistoryWatcherState.initial(),
      );

      when(mockBloc.state).thenReturn(
        const TransactionHistoryWatcherState.loadSuccess([]),
      );
    },
  );

  tearDown(() async => getIt.reset());

  Widget build(User userToDisplay) => MaterialApp(
    home: Scaffold(
      body: BlocProvider<TransactionHistoryWatcherBloc>.value(
        value: mockBloc,
        child: ProfileContent(user: userToDisplay),
      ),
    ),
  );

  testWidgets(
    'renders user info correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(build(user));

      // Assert
      expect(find.text(user.name.getOrCrash()), findsOneWidget);
      expect(find.text('@${user.username.getOrCrash()}'), findsOneWidget);
      expect(find.text(user.bio.getOrCrash()), findsOneWidget);
    },
  );

  testWidgets(
    'shows verified badge when user.isVerified is true',
    (
      tester,
    ) async {
      // Arrange
      final verifiedUser = user.copyWith(isVerified: true);

      // Act
      await tester.pumpWidget(build(verifiedUser));

      // Assert
      expect(find.byIcon(Icons.verified), findsOneWidget);
    },
  );

  testWidgets(
    'shows transaction history placeholder text',
    (tester) async {
      // Act
      await tester.pumpWidget(build(user));

      // Assert
      expect(find.text('No transactions yet.'), findsOneWidget);
    },
  );

  testWidgets(
    'shows edit profile button',
    (tester) async {
      // Act
      await tester.pumpWidget(build(user));

      // Assert
      expect(find.byIcon(Icons.edit), findsOneWidget);
    },
  );
}
