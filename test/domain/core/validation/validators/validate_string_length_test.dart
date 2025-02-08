import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_string_length.dart';

void main() {
  const length = 5;
  group(
    'Testing on success',
    () {
      test(
        'should return the input string when it is empty',
        () {
          // Arrange
          const input = '';

          // Act
          final result = validateStringLength(input: input, length: length);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input string '
        'when its length is less than the max length',
        () {
          // Arrange
          const input = 'abc';

          // Act
          final result = validateStringLength(input: input, length: length);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input string '
        'when its length is equal to the max length',
        () {
          // Arrange
          const input = 'abcde';

          // Act
          final result = validateStringLength(input: input, length: length);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the trimmed input string '
        'when its length is greater than the max length due to empty space',
        () {
          // Arrange
          const input = 'abcde  ';

          // Act
          final result = validateStringLength(input: input, length: length);

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
        'should return a Failure.stringExceedsLength '
        'when the input length is greater than the max length',
        () {
          // Arrange
          const input = 'abcdef';

          // Act
          final result = validateStringLength(input: input, length: length);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.stringExceedsLength(
                failedValue: input,
                maxLength: length,
              ),
            ),
          );
        },
      );
    },
  );
}
