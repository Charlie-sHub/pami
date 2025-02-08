import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/name.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a Name with the input value when the input is valid',
        () {
          // Arrange
          const validName = 'John Doe';
          final validNameObject = Name(validName);

          // Act
          final result = validNameObject.value;

          // Assert
          expect(result, right(validName));
        },
      );

      test(
        'should return a Name with the input value '
        'when the input is at max length',
        () {
          // Arrange
          final maxLengthName = 'a' * Name.maxLength;
          final maxLengthNameObject = Name(maxLengthName);

          // Act
          final result = maxLengthNameObject.value;

          // Assert
          expect(result, right(maxLengthName));
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
          final overMaxLengthName = 'a' * (Name.maxLength + 1);
          final overMaxLengthNameObject = Name(overMaxLengthName);

          // Act
          final result = overMaxLengthNameObject.value;

          // Assert
          expect(
            result,
            left(
              Failure<String>.stringExceedsLength(
                failedValue: overMaxLengthName,
                maxLength: Name.maxLength,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.emptyString when the input is empty',
        () {
          // Arrange
          const emptyName = '';
          final emptyNameObject = Name(emptyName);

          // Act
          final result = emptyNameObject.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.emptyString(failedValue: emptyName),
            ),
          );
        },
      );

      test(
        'should return a Failure.multiLineString '
        'when the input contains multiple lines',
        () {
          // Arrange
          const multiLineName = 'John\nDoe';
          final multiLineNameObject = Name(multiLineName);

          // Act
          final result = multiLineNameObject.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.multiLineString(
                failedValue: multiLineName,
              ),
            ),
          );
        },
      );
    },
  );
}
