import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_bounded_double.dart';

void main() {
  const double max = 100;

  group(
    'Testing on success',
    () {
      test(
        'should return the input integer when it is within the bounds',
        () {
          // Arrange
          const double input = 50;

          // Act
          final result = validateBoundedDouble(input: input, max: max);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input integer when it is equal to the min',
        () {
          // Arrange
          const double input = 0;

          // Act
          final result = validateBoundedDouble(input: input, max: max);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input integer when it is equal to the max',
        () {
          // Arrange
          const double input = 100;

          // Act
          final result = validateBoundedDouble(input: input, max: max);

          // Assert
          expect(result, right(input));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input is less than the min',
        () {
          // Arrange
          const input = -1.0;

          // Act
          final result = validateBoundedDouble(input: input, max: max);

          // Assert
          expect(
            result,
            left<Failure<double>, double>(
              const Failure.doubleOutOfBounds(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input is greater than the max',
        () {
          // Arrange
          const double input = 101;

          // Act
          final result = validateBoundedDouble(input: input, max: max);

          // Assert
          expect(
            result,
            left<Failure<double>, double>(
              const Failure.doubleOutOfBounds(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input is a double less than the min',
        () {
          // Arrange
          const input = -1.5;

          // Act
          final result = validateBoundedDouble(input: input, max: max);

          // Assert
          expect(
            result,
            left<Failure<double>, double>(
              const Failure.doubleOutOfBounds(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input is a double greater than the max',
        () {
          // Arrange
          const input = 100.5;

          // Act
          final result = validateBoundedDouble(input: input, max: max);

          // Assert
          expect(
            result,
            left<Failure<double>, double>(
              const Failure.doubleOutOfBounds(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
