import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/views/profile/widgets/outcome_icon.dart';

void main() {
  Widget build({required bool? isPositive}) => MaterialApp(
    home: Scaffold(
      body: OutcomeIcon(isPositive: isPositive),
    ),
  );

  testWidgets(
    'shows a green thumbs up icon when isPositive is true',
    (tester) async {
      // Arrange
      const isPositive = true;

      // Act
      await tester.pumpWidget(build(isPositive: isPositive));

      // Assert
      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.icon, Icons.thumb_up);
      expect(iconWidget.color, Colors.green);
    },
  );

  testWidgets(
    'shows a red thumbs down icon when isPositive is false',
    (tester) async {
      // Arrange
      const isPositive = false;

      // Act
      await tester.pumpWidget(build(isPositive: isPositive));

      // Assert
      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.icon, Icons.thumb_down);
      expect(iconWidget.color, Colors.red);
    },
  );

  testWidgets(
    'shows a grey remove icon when isPositive is null',
    (tester) async {
      // Arrange
      const bool? isPositive = null;

      // Act
      await tester.pumpWidget(build(isPositive: isPositive));

      // Assert
      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.icon, Icons.remove);
      expect(iconWidget.color, Colors.grey);
    },
  );
}
