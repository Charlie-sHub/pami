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
          const input = 'John Doe';

          // Act
          final result = Name(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Name with the input value '
        'when the input is at max length',
        () {
          // Arrange
          final input = 'a' * Name.maxLength;

          // Act
          final result = Name(input);

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
          final input = 'a' * (Name.maxLength + 1);

          // Act
          final result = Name(input);

          // Assert
          expect(
            result.value,
            left(
              Failure<String>.stringExceedsLength(
                failedValue: input,
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
          // Arrange
          const input = '';

          // Act
          final result = Name(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.emptyString(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.multiLineString '
        'when the input contains multiple lines',
        () {
          // Arrange
          const input = 'John\nDoe';

          // Act
          final result = Name(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.multiLineString(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
