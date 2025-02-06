import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_password.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input password when it has 6 characters',
        () {
          // Arrange
          const input = 'abcdef';

          // Act
          final result = validatePassword(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input password '
        'when it has more than 6 characters',
        () {
          // Arrange
          const input = 'abcdefg';

          // Act
          final result = validatePassword(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input password when it has special characters',
        () {
          // Arrange
          const input = 'abc*123';

          // Act
          final result = validatePassword(input);

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
        'should return a Failure.invalidPassword '
        'when the input password is empty',
        () {
          // Arrange
          const input = '';

          // Act
          final result = validatePassword(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidPassword(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidPassword '
        'when the input password has less than 6 characters',
        () {
          // Arrange
          const input = 'abcde';

          // Act
          final result = validatePassword(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidPassword(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
