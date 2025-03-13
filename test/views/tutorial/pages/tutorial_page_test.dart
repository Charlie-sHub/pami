import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/views/tutorial/pages/tutorial_page.dart';
import 'package:pami/views/tutorial/widgets/tutorial_button.dart';
import 'package:pami/views/tutorial/widgets/tutorial_carousel.dart';
import 'package:pami/views/tutorial/widgets/tutorial_indicator.dart';

void main() {
  Widget buildWidget() => const MaterialApp(
        home: TutorialPage(),
      );

  testWidgets(
    'renders all expected widgets',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(TutorialCarousel), findsOneWidget);
      expect(find.byType(TutorialIndicator), findsOneWidget);
      expect(find.byType(TutorialButton), findsOneWidget);
    },
  );
}
