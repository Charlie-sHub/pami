import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/views/profile/widgets/outcome_icon.dart';
import 'package:pami/views/profile/widgets/transaction_card.dart';

void main() {
  Widget build(Transaction transaction) => MaterialApp(
    home: Scaffold(
      body: TransactionCard(transaction: transaction),
    ),
  );

  testWidgets(
    'displays the transaction title',
    (tester) async {
      // Arrange
      final transaction = getValidTransaction();
      final title = transaction.shoutOutTitle.value.fold(
        (_) => '',
        (value) => value,
      );

      // Act
      await tester.pumpWidget(build(transaction));

      // Assert
      expect(find.text(title), findsOneWidget);
    },
  );

  testWidgets(
    'displays the shout out type emoji for offer',
    (tester) async {
      // Arrange
      final transaction = getValidTransaction().copyWith(
        shoutOutType: ShoutOutType.offer,
      );

      // Act
      await tester.pumpWidget(build(transaction));

      // Assert
      expect(find.text('🤝'), findsOneWidget);
    },
  );

  testWidgets(
    'displays the shout out type emoji for request',
    (tester) async {
      // Arrange
      final transaction = getValidTransaction().copyWith(
        shoutOutType: ShoutOutType.request,
      );

      // Act
      await tester.pumpWidget(build(transaction));

      // Assert
      expect(find.text('🙋‍♂️'), findsOneWidget);
    },
  );

  testWidgets(
    'displays the date created text',
    (tester) async {
      // Arrange
      final transaction = getValidTransaction();
      final dateString = transaction.dateCreated.value.fold(
        (_) => '',
        (value) => value.toString(),
      );

      // Act
      await tester.pumpWidget(build(transaction));

      // Assert
      expect(find.text(dateString), findsOneWidget);
    },
  );

  testWidgets(
    'passes isPositive = true to OutcomeIcon '
    'when transaction is positive for creator',
    (tester) async {
      // Arrange
      final transaction = getValidTransaction().copyWith(
        isPositiveForCreator: some(true),
      );

      // Act
      await tester.pumpWidget(build(transaction));

      // Assert
      final outcomeIcon = tester.widget<OutcomeIcon>(find.byType(OutcomeIcon));
      expect(outcomeIcon.isPositive, true);
    },
  );

  testWidgets(
    'passes isPositive = false to OutcomeIcon '
    'when transaction is negative for creator',
    (tester) async {
      // Arrange
      final transaction = getValidTransaction().copyWith(
        isPositiveForCreator: some(false),
      );

      // Act
      await tester.pumpWidget(build(transaction));

      // Assert
      final outcomeIcon = tester.widget<OutcomeIcon>(find.byType(OutcomeIcon));
      expect(outcomeIcon.isPositive, false);
    },
  );

  testWidgets(
    'passes isPositive = null to OutcomeIcon '
    'when transaction has no outcome yet',
    (tester) async {
      // Arrange
      final transaction = getValidTransaction().copyWith(
        isPositiveForCreator: none(),
      );

      // Act
      await tester.pumpWidget(build(transaction));

      // Assert
      final outcomeIcon = tester.widget<OutcomeIcon>(find.byType(OutcomeIcon));
      expect(outcomeIcon.isPositive, null);
    },
  );
}
