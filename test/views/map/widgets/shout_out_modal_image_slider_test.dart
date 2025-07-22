import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/views/map/widgets/shout_out_modal_image_slider.dart';

void main() {
  Widget buildWidget(Set<Url> imageUrls) => MaterialApp(
    home: Scaffold(
      body: ShoutOutModalImageSlider(imageUrls: imageUrls),
    ),
  );

  testWidgets(
    'renders Icon when imageUrls is empty (Set is empty)',
    (tester) async {
      // Arrange
      const emptyImageUrlsSet = <Url>{};

      // Act
      await tester.pumpWidget(buildWidget(emptyImageUrlsSet));

      // Assert
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
      expect(find.byType(CarouselSlider), findsNothing);
    },
  );

  testWidgets(
    'renders CarouselSlider with placeholder '
    '(ClipRRect containing Icon) for Urls with empty strings',
    (tester) async {
      // Arrange
      final imageUrlsWithEmptyStrings = {
        Url(''),
        Url(''),
      };

      // Act
      await tester.pumpWidget(buildWidget(imageUrlsWithEmptyStrings));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CarouselSlider), findsOneWidget);
      expect(
        find.byType(ClipRRect),
        findsNWidgets(imageUrlsWithEmptyStrings.length),
      );
      expect(
        find.byIcon(Icons.broken_image),
        findsNWidgets(imageUrlsWithEmptyStrings.length),
      );
      expect(find.byType(Image), findsNothing);
    },
  );

  testWidgets(
    'renders CarouselSlider with one placeholder '
    'for a single Url with an empty string',
    (tester) async {
      // Arrange
      final imageUrlsWithSingleEmptyString = {
        Url(''),
      };

      // Act
      await tester.pumpWidget(
        buildWidget(imageUrlsWithSingleEmptyString),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CarouselSlider), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    },
  );

  testWidgets(
    'renders CarouselSlider with placeholders for various '
    'invalid Url strings by sliding',
    (tester) async {
      // Arrange
      final variousInvalidImageUrlsList = {
        Url(''),
        Url('not a valid url format'),
        Url('htp://missing-protocol-part.com'),
      };

      // Act
      await tester.pumpWidget(
        buildWidget(variousInvalidImageUrlsList.toSet()),
      );
      await tester.pumpAndSettle();

      // Assert
      final carouselFinder = find.byType(CarouselSlider);
      expect(carouselFinder, findsOneWidget);

      for (var i = 0; i < variousInvalidImageUrlsList.length; i++) {
        expect(
          find.descendant(
            of: carouselFinder,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is ClipRRect &&
                  tester.any(
                    find.descendant(
                      of: find.byWidget(widget),
                      matching: find.byIcon(Icons.broken_image),
                    ),
                  ),
            ),
          ),
          findsWidgets,
        );
        expect(find.byType(Image), findsNothing);

        if (i < variousInvalidImageUrlsList.length - 1) {
          await tester.drag(carouselFinder, const Offset(-400, 0));
          await tester.pumpAndSettle();
        }
      }
    },
  );
}
