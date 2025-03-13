import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/views/tutorial/widgets/tutorial_slide.dart';

void main() {
  Widget buildWidget({required String title, required String description}) =>
      MaterialApp(
        home: Scaffold(
          body: TutorialSlide(
            title: title,
            description: description,
          ),
        ),
      );

  testWidgets(
    'TutorialSlide renders correctly',
    (tester) async {
      // Arrange
      const title = 'Test Title';
      const description = 'Test Description';

      // Act
      await tester.pumpWidget(
        buildWidget(title: title, description: description),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    },
  );
}
