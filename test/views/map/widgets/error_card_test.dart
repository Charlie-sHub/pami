import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart'; // Ensure this path is correct
import 'package:pami/views/core/theme/colors.dart';
import 'package:pami/views/map/widgets/error_card.dart'; // Update with the correct path

void main() {
  Widget buildWidget({required Failure failure}) => MaterialApp(
    home: Scaffold(
      body: ErrorCard(failure: failure),
    ),
  );

  testWidgets(
    'renders correctly with a ServerError failure message',
    (tester) async {
      // Arrange
      const testErrorMessage = 'Network connection lost.';
      const testFailure = Failure.serverError(
        errorString: testErrorMessage,
      );

      // Act
      await tester.pumpWidget(buildWidget(failure: testFailure));

      // Assert
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);
      expect(tester.widget<Card>(cardFinder).color, AppColors.onError);

      final textFinder = find.text(
        'Error loading shout-outs: ${testFailure.message}',
      );
      expect(textFinder, findsOneWidget);
      expect(tester.widget<Text>(textFinder).style?.color, Colors.white);
    },
  );

  testWidgets(
    'renders correctly when the dynamic part of a message is empty'
    ' (e.g., ServerError with empty string)',
    (tester) async {
      // Arrange
      const emptyServerErrorMessage = Failure.serverError(errorString: '');

      // Act
      await tester.pumpWidget(
        buildWidget(failure: emptyServerErrorMessage),
      );

      // Assert
      expect(
        find.text('Error loading shout-outs: Server error: '),
        findsOneWidget,
      );
    },
  );
}
