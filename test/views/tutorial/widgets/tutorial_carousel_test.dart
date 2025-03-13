import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/views/tutorial/data/tutorial_slides.dart';
import 'package:pami/views/tutorial/widgets/tutorial_carousel.dart';
import 'package:pami/views/tutorial/widgets/tutorial_slide.dart';

void main() {
  Widget buildWidget({required void Function(int) onPageChanged}) =>
      MaterialApp(
        home: Scaffold(
          body: TutorialCarousel(
            slides: tutorialSlides,
            controller: CarouselSliderController(),
            onPageChanged: onPageChanged,
          ),
        ),
      );

  testWidgets(
    'TutorialCarousel renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(onPageChanged: (index) {}));

      // Assert
      expect(find.byType(CarouselSlider), findsOneWidget);
      expect(find.byType(TutorialSlide), findsOneWidget);
    },
  );

  testWidgets(
    'TutorialCarousel calls onPageChanged callback',
    (tester) async {
      // Arrange
      int? capturedIndex;
      await tester.pumpWidget(
        buildWidget(
          onPageChanged: (index) => capturedIndex = index,
        ),
      );
      await tester.pumpAndSettle();

      // Act
      final carousel = find.byType(CarouselSlider);
      await tester.drag(carousel, const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Assert
      expect(capturedIndex, 1);

      // Act
      await tester.drag(carousel, const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Assert
      expect(capturedIndex, 2);
    },
  );
}
