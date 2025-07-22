import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/views/tutorial/data/tutorial_slides.dart';
import 'package:pami/views/tutorial/widgets/tutorial_indicator.dart';

import 'tutorial_indicator_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CarouselSliderController>(),
])
void main() {
  late MockCarouselSliderController mockController;

  setUp(() => mockController = MockCarouselSliderController());

  Widget buildWidget(int index) => MaterialApp(
        home: Scaffold(
          body: TutorialIndicator(
            slideCount: tutorialSlides.length,
            currentIndex: index,
            controller: mockController,
          ),
        ),
      );

  testWidgets(
    'TutorialIndicator renders correctly',
    (tester) async {
      //Act
      await tester.pumpWidget(buildWidget(0));

      //Assert
      expect(find.byType(Row), findsOneWidget);
      expect(
        find.byType(GestureDetector),
        findsNWidgets(tutorialSlides.length),
      );
    },
  );

  testWidgets(
    'TutorialIndicator updates when page changes',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(0));
      final indicator = tester.widget<TutorialIndicator>(
        find.byType(TutorialIndicator),
      );

      // Assert
      expect(indicator.currentIndex, 0);

      // Act
      await tester.pumpWidget(buildWidget(1));
      final updatedIndicator = tester.widget<TutorialIndicator>(
        find.byType(TutorialIndicator),
      );

      // Assert
      expect(updatedIndicator.currentIndex, 1);

      // Act
      await tester.pumpWidget(buildWidget(2));
      final secondUpdatedIndicator = tester.widget<TutorialIndicator>(
        find.byType(TutorialIndicator),
      );

      // Assert
      expect(secondUpdatedIndicator.currentIndex, 2);
    },
  );

  testWidgets(
    'TutorialIndicator navigates to correct page when tapped',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(0));
      await tester.tap(find.byType(GestureDetector).at(2));

      // Assert
      verify(mockController.animateToPage(2)).called(1);
    },
  );
}
