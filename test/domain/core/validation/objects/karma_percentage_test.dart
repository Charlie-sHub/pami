import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a KarmaPercentage with the input value '
        'when the input is valid',
        () {
          // Arrange
          const input = 50.0;

          // Act
          final result = KarmaPercentage(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a KarmaPercentage with the input value '
        'when the input is at the limit',
        () {
          // Arrange
          const input = KarmaPercentage.limit;

          // Act
          final result = KarmaPercentage(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a KarmaPercentage with the input value '
        'when the input is 0',
        () {
          // Arrange
          const input = 0.0;

          // Act
          final result = KarmaPercentage(input);

          // Assert
          expect(result.value, right(input));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the limit',
        () {
          // Arrange
          const input = KarmaPercentage.limit + 0.1;

          // Act
          final result = KarmaPercentage(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<double>.doubleOutOfBounds(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.doubleOutOfBounds when the input is negative',
        () {
          // Arrange
          const input = -1.0;

          // Act
          final result = KarmaPercentage(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<double>.doubleOutOfBounds(failedValue: input),
            ),
          );
        },
      );
    },
  );

  group(
    'Testing on percentage',
    () {
      test(
        'should return the correct percentage when the value is right',
        () {
          // Arrange
          const input = 50.0;
          final karmaPercentage = KarmaPercentage(input);

          // Act
          final result = karmaPercentage.percentage;

          // Assert
          expect(result, input);
        },
      );

      test(
        'should return 0.0 when the value is left',
        () {
          // Arrange
          const input = KarmaPercentage.limit + 0.1;
          final karmaPercentage = KarmaPercentage(input);

          // Act
          final result = karmaPercentage.percentage;

          // Assert
          expect(result, 0.0);
        },
      );
    },
  );

  group(
    'Testing on leftPercentage',
    () {
      test(
        'should return the correct left percentage when the value is right',
        () {
          // Arrange
          const input = 50.0;
          final karmaPercentage = KarmaPercentage(input);

          // Act
          final result = karmaPercentage.leftPercentage;

          // Assert
          expect(result, 50.0);
        },
      );

      test(
        'should return 100.0 when the value is left',
        () {
          // Arrange
          const input = KarmaPercentage.limit + 0.1;
          final karmaPercentage = KarmaPercentage(input);

          // Act
          final result = karmaPercentage.leftPercentage;

          // Assert
          expect(result, 100.0);
        },
      );
    },
  );
}
