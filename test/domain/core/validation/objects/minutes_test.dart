import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a Minutes with the input value when the input is valid',
        () {
          // Arrange
          const input = 720.0; // Half of the limit

          // Act
          final result = Minutes(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Minutes with the input value '
        'when the input is at the limit',
        () {
          // Arrange
          const input = Minutes.limit;

          // Act
          final result = Minutes(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Minutes with the input value when the input is 0',
        () {
          // Arrange
          const input = 0.0;

          // Act
          final result = Minutes(input);

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
          const input = Minutes.limit + 0.1;

          // Act
          final result = Minutes(input);

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
          final result = Minutes(input);

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
}
