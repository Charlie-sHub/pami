import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_bounded_num.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input integer when it is within the bounds',
        () {
          // Arrange
          const input = 50;
          const max = 100;

          // Act
          final result = validateBoundedNum(input: input, max: max);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input integer when it is equal to the min',
        () {
          // Arrange
          const input = 0;
          const max = 100;

          // Act
          final result = validateBoundedNum(input: input, max: max);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input integer when it is equal to the max',
        () {
          // Arrange
          const input = 100;
          const max = 100;

          // Act
          final result = validateBoundedNum(input: input, max: max);

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
        'should return a Failure.numOutOfBounds '
        'when the input is less than the min',
        () {
          // Arrange
          const input = -1;
          const max = 100;

          // Act
          final result = validateBoundedNum(input: input, max: max);

          // Assert
          expect(
            result,
            left<Failure<num>, num>(
              const Failure.numOutOfBounds(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.numOutOfBounds '
        'when the input is greater than the max',
        () {
          // Arrange
          const input = 101;
          const max = 100;

          // Act
          final result = validateBoundedNum(input: input, max: max);

          // Assert
          expect(
            result,
            left<Failure<num>, num>(
              const Failure.numOutOfBounds(failedValue: input),
            ),
          );
        },
      );
      test(
        'should return a Failure.numOutOfBounds '
        'when the input is a double less than the min',
        () {
          // Arrange
          const input = -1.5;
          const max = 100;

          // Act
          final result = validateBoundedNum(input: input, max: max);

          // Assert
          expect(
            result,
            left<Failure<num>, num>(
              const Failure.numOutOfBounds(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.numOutOfBounds '
        'when the input is a double greater than the max',
        () {
          // Arrange
          const input = 100.5;
          const max = 100;

          // Act
          final result = validateBoundedNum(input: input, max: max);

          // Assert
          expect(
            result,
            left<Failure<num>, num>(
              const Failure.numOutOfBounds(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
