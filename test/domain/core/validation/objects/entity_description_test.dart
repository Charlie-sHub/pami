import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';

void main() {
  group(
    'Testing on success',
    () {
      const validDescription = 'This is a valid description.';
      final maxLengthDescription = 'a' * EntityDescription.maxLength;
      final validEntityDescription = EntityDescription(validDescription);
      final maxLengthEntityDescription = EntityDescription(
        maxLengthDescription,
      );

      test(
        'should return a EntityDescription with the input value '
        'when the input is valid',
        () {
          // Assert
          expect(validEntityDescription.value, right(validDescription));
        },
      );

      test(
        'should return a EntityDescription with the input value '
        'when the input is at max length',
        () {
          // Assert
          expect(maxLengthEntityDescription.value, right(maxLengthDescription));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      final overMaxLengthDescription = 'a' * (EntityDescription.maxLength + 1);
      const emptyDescription = '';
      final overMaxLengthEntityDescription = EntityDescription(
        overMaxLengthDescription,
      );
      final emptyEntityDescription = EntityDescription(emptyDescription);

      test(
        'should return a Failure.stringExceedsLength '
        'when the input exceeds the max length',
        () {
          // Assert
          expect(
            overMaxLengthEntityDescription.value,
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
        'should return a Failure.emptyString '
        'when the input is empty',
        () {
          // Assert
          expect(
            emptyEntityDescription.value,
            left(
              const Failure<String>.emptyString(failedValue: emptyDescription),
            ),
          );
        },
      );
    },
  );
}
