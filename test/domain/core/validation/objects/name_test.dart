import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/name.dart';

void main() {
  group(
    'Testing on success',
    () {
      const validName = 'John Doe';
      final maxLengthName = 'a' * Name.maxLength;
      final validNameObject = Name(validName);
      final maxLengthNameObject = Name(maxLengthName);

      test(
        'should return a Name with the input value when the input is valid',
        () {
          // Assert
          expect(validNameObject.value, right(validName));
        },
      );

      test(
        'should return a Name with the input value '
        'when the input is at max length',
        () {
          // Assert
          expect(maxLengthNameObject.value, right(maxLengthName));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      final overMaxLengthName = 'a' * (Name.maxLength + 1);
      const emptyName = '';
      const multiLineName = 'John\nDoe';
      final overMaxLengthNameObject = Name(overMaxLengthName);
      final emptyNameObject = Name(emptyName);
      final multiLineNameObject = Name(multiLineName);

      test(
        'should return a Failure.stringExceedsLength '
        'when the input exceeds the max length',
        () {
          // Assert
          expect(
            overMaxLengthNameObject.value,
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
        'should return a Failure.emptyString '
        'when the input is empty',
        () {
          // Assert
          expect(
            emptyNameObject.value,
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
          // Assert
          expect(
            multiLineNameObject.value,
            left(
              const Failure<String>.multiLineString(failedValue: multiLineName),
            ),
          );
        },
      );
    },
  );
}
