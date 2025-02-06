import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input string when it is not empty',
        () {
          // Arrange
          const input = 'This is a non-empty string';

          // Act
          final result = validateStringNotEmpty(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input string when it contains spaces and characters',
        () {
          // Arrange
          const input = '   a   ';

          // Act
          final result = validateStringNotEmpty(input);

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
        'should return a Failure.emptyString when the input string is empty',
        () {
          // Arrange
          const input = '';

          // Act
          final result = validateStringNotEmpty(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.emptyString(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.emptyString '
        'when the input string contains only spaces',
        () {
          // Arrange
          const input = '   ';

          // Act
          final result = validateStringNotEmpty(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.emptyString(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
