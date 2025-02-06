import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_max_length_set.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input iterable when it is empty',
        () {
          // Arrange
          const input = <int>{};
          const maxLength = 5;

          // Act
          final result = validateMaxLengthSet(
            input: input,
            maxLength: maxLength,
          );

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input iterable '
        'when its length is less than the max length',
        () {
          // Arrange
          const input = {1, 2, 3};
          const maxLength = 5;

          // Act
          final result =
              validateMaxLengthSet(input: input, maxLength: maxLength);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input iterable '
        'when its length is equal to the max length',
        () {
          // Arrange
          const input = {1, 2, 3, 4, 5};
          const maxLength = 5;

          // Act
          final result =
              validateMaxLengthSet(input: input, maxLength: maxLength);

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
        'should return a Failure.collectionExceedsLength '
        'when the input length is greater than the max length',
        () {
          // Arrange
          const input = {1, 2, 3, 4, 5, 6};
          const maxLength = 5;

          // Act
          final result =
              validateMaxLengthSet(input: input, maxLength: maxLength);

          // Assert
          expect(
            result,
            left<Failure<Set<int>>, Set<int>>(
              const Failure.collectionExceedsLength(
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
