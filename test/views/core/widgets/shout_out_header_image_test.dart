import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/views/home/widgets/shout_out_header_image.dart';

void main() {
  Widget buildWidget({
    required List<Url> imageUrls,
    required VoidCallback onDismiss,
  }) => MaterialApp(
    home: Scaffold(
      body: ShoutOutHeaderImage(
        imageUrls: imageUrls,
        onDismiss: onDismiss,
      ),
    ),
  );

  testWidgets(
    'renders placeholder (no images) and close button, tapping calls onDismiss',
    (tester) async {
      // Arrange
      var tapped = 0;
      int onDismiss() => tapped++;

      // Act
      await tester.pumpWidget(
        buildWidget(
          imageUrls: const [],
          onDismiss: onDismiss,
        ),
      );

      // Assert UI
      expect(find.byType(AspectRatio), findsOneWidget);
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(CarouselSlider), findsNothing);
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Assert behavior
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(tapped, 1);
    },
  );

  testWidgets(
    'renders carousel when imageUrls not empty',
    // Skipping because of the HTTP issues during tests
    skip: true,
    (tester) async {
      // Arrange
      final urls = [
        Url('https://example.com/1.jpg'),
        Url('https://example.com/2.jpg'),
      ];

      // Act
      await tester.pumpWidget(
        buildWidget(
          imageUrls: urls,
          onDismiss: () {},
        ),
      );

      // Assert
      expect(find.byType(CarouselSlider), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
    },
  );
}
