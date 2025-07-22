import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/views/splash/widgets/pami_loading_animation.dart';

void main() {
  const letters = ['P', 'A', 'M', 'I'];

  Widget buildWidget() => const MaterialApp(
        home: Scaffold(
          body: PamiLoadingAnimation(),
        ),
      );

  testWidgets(
    'renders all letters',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      for (final letter in letters) {
        expect(find.text(letter), findsOneWidget);
      }
    },
  );

  testWidgets(
    'animates letters continuously',
    (tester) async {
      // Arrange
      const initialFontSize = 20.0;
      const maxFontSize = 30.0;

      // Act
      await tester.pumpWidget(buildWidget());
      final initialFontSizes = <String, double>{};
      for (final letter in letters) {
        final textFinder = find.text(letter);
        final textWidget = tester.widget<Text>(textFinder);
        initialFontSizes[letter] =
            textWidget.style?.fontSize ?? initialFontSize;
      }

      var previousSizes = letters
          .map(
            (letter) => initialFontSizes[letter]!,
          )
          .toList();
      var sizeChanged = false;

      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));

        final currentSizes = <double>[];
        for (final letter in letters) {
          final textFinder = find.text(letter);
          final textWidget = tester.widget<Text>(textFinder);
          final currentSize = textWidget.style?.fontSize ?? initialFontSize;
          currentSizes.add(currentSize);

          expect(currentSize, greaterThanOrEqualTo(initialFontSize));
          expect(currentSize, lessThanOrEqualTo(maxFontSize));
        }

        for (var j = 0; j < letters.length; j++) {
          if (currentSizes[j] != previousSizes[j]) {
            sizeChanged = true;
            break;
          }
        }

        previousSizes = List.from(currentSizes);
      }

      // Assert
      expect(sizeChanged, isTrue);
    },
  );
}
