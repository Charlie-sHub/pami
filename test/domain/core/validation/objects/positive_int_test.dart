import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/positive_int.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a PositiveInt with the input value '
        'when the input is a small positive int',
        () {
          // Arrange
          const input = 1;
          final smallPositiveIntObject = PositiveInt(input);

          // Act
          final result = smallPositiveIntObject.value;

          // Assert
          expect(result, right<ValueFailure<int>, int>(1));
        },
      );

      test(
        'should return a PositiveInt with the input value '
        'when the input is a larger positive int',
        () {
          // Arrange
          const input = 42;
          final largerPositiveIntObject = PositiveInt(input);

          // Act
          final result = largerPositiveIntObject.value;

          // Assert
          expect(result, right<ValueFailure<int>, int>(42));
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
          final negativeIntObject = PositiveInt(input);

          // Act
          final result = negativeIntObject.value;

          // Assert
          expect(
            result,
            left<ValueFailure<int>, int>(
              const ValueFailure.intOutOfBounds(
                failedValue: -1,
              ),
            ),
          );
        },
      );
    },
  );
}
