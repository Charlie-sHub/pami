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
          const validDescription = 'This is a valid description.';
          final validEntityDescription = EntityDescription(
            validDescription,
          );

          // Act
          final result = validEntityDescription.value;

          // Assert
          expect(result, right(validDescription));
        },
      );

      test(
        'should return a EntityDescription with the input value '
        'when the input is at max length',
        () {
          // Arrange
          final maxLengthDescription = 'a' * EntityDescription.maxLength;
          final maxLengthEntityDescription = EntityDescription(
            maxLengthDescription,
          );

          // Act
          final result = maxLengthEntityDescription.value;

          // Assert
          expect(result, right(maxLengthDescription));
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
          final overMaxLengthDescription =
              'a' * (EntityDescription.maxLength + 1);
          final overMaxLengthEntityDescription = EntityDescription(
            overMaxLengthDescription,
          );

          // Act
          final result = overMaxLengthEntityDescription.value;

          // Assert
          expect(
            result,
            left(
              Failure<String>.stringExceedsLength(
                failedValue: overMaxLengthDescription,
                maxLength: EntityDescription.maxLength,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.emptyString when the input is empty',
        () {
          // Arrange
          const emptyDescription = '';
          final emptyEntityDescription = EntityDescription(
            emptyDescription,
          );

          // Act
          final result = emptyEntityDescription.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.emptyString(
                failedValue: emptyDescription,
              ),
            ),
          );
        },
      );
    },
  );
}
