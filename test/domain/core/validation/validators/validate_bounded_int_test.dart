import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/validators/validate_bounded_int.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input int when it is greater than zero',
        () {
          // Arrange
          const input = 1;

          // Act
          final result = validateBoundedInteger(input: input);

          // Assert
          expect(result, right<ValueFailure<int>, int>(input));
        },
      );

      test(
        'should return the input int when it is a larger positive number',
        () {
          // Arrange
          const input = 42;

          // Act
          final result = validateBoundedInteger(input: input);

          // Assert
          expect(result, right<ValueFailure<int>, int>(input));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a ValueFailure.intOutOfBounds '
        'when the input is negative',
        () {
          // Arrange
          const input = -1;

          // Act
          final result = validateBoundedInteger(input: input);

          // Assert
          expect(
            result,
            left<ValueFailure<int>, int>(
              const ValueFailure.intOutOfBounds(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a ValueFailure.intOutOfBounds when the input is '
        'a larger negative number',
        () {
          // Arrange
          const input = -100;

          // Act
          final result = validateBoundedInteger(input: input);

          // Assert
          expect(
            result,
            left<ValueFailure<int>, int>(
              const ValueFailure.intOutOfBounds(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
