import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/validators/validate_max_length_set.dart';

void main() {
  const maxLength = 5;

  group(
    'Testing on success',
    () {
      test(
        'should return the input iterable when it is empty',
        () {
          // Arrange
          const input = <int>{};

          // Act
          final result = validateMaxLengthSet(
            input: input,
            maxLength: maxLength,
          );

          // Assert
          expect(result, right<ValueFailure<Set<int>>, Set<int>>(input));
        },
      );

      test(
        'should return the input iterable '
        'when its length is less than the max length',
        () {
          // Arrange
          const input = {1, 2, 3};

          // Act
          final result = validateMaxLengthSet(
            input: input,
            maxLength: maxLength,
          );

          // Assert
          expect(result, right<ValueFailure<Set<int>>, Set<int>>(input));
        },
      );

      test(
        'should return the input iterable '
        'when its length is equal to the max length',
        () {
          // Arrange
          const input = {1, 2, 3, 4, 5};

          // Act
          final result = validateMaxLengthSet(
            input: input,
            maxLength: maxLength,
          );

          // Assert
          expect(result, right<ValueFailure<Set<int>>, Set<int>>(input));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a ValueFailure.collectionExceedsLength '
        'when the input length is greater than the max length',
        () {
          // Arrange
          const input = {1, 2, 3, 4, 5, 6};

          // Act
          final result = validateMaxLengthSet(
            input: input,
            maxLength: maxLength,
          );

          // Assert
          expect(
            result,
            left<ValueFailure<Set<int>>, Set<int>>(
              const ValueFailure.collectionExceedsLength(
                failedValue: input,
                maxLength: maxLength,
              ),
            ),
          );
        },
      );
    },
  );
}
