import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a EntityDescription with the input value '
        'when the input is valid',
        () {
          // Arrange
          const input = 'This is a valid description.';

          // Act
          final result = EntityDescription(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a EntityDescription with the input value '
        'when the input is at max length',
        () {
          // Arrange
          final input = 'a' * EntityDescription.maxLength;

          // Act
          final result = EntityDescription(input);

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
        'should return a Failure.stringExceedsLength '
        'when the input exceeds the max length',
        () {
          // Arrange
          final input = 'a' * (EntityDescription.maxLength + 1);

          // Act
          final result = EntityDescription(input);

          // Assert
          expect(
            result.value,
            left(
              Failure<String>.stringExceedsLength(
                failedValue: input,
                maxLength: EntityDescription.maxLength,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.emptyString '
        'when the input is empty',
        () {
          // Arrange
          const input = '';

          // Act
          final result = EntityDescription(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.emptyString(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
