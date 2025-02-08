import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_password.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input password when it is a valid password',
        () {
          // Arrange
          const input = 'ValidP@sswOrd123';

          // Act
          final result = validatePassword(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input password '
        'when it is a valid password with special characters',
        () {
          // Arrange
          const input = r'V@l!dP@$$wOrd123#';

          // Act
          final result = validatePassword(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input password '
        'when it is a valid password with more special characters',
        () {
          // Arrange
          const input = r'V@l!dP@$$wOrd123#$&';

          // Act
          final result = validatePassword(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input password '
        'when it is a valid password with more numbers',
        () {
          // Arrange
          const input = r'V@l!dP@$$wOrd123456789#';

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
        'when the input is an empty string',
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
        'should return a Failure.invalidPassword when the input is too short',
        () {
          // Arrange
          const input = 'Short1@';

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
        'when the input does not contain a number',
        () {
          // Arrange
          const input = 'NoNumberPassword@';

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
        'when the input does not contain an uppercase letter',
        () {
          // Arrange
          const input = 'nopassword123@';

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
        'when the input does not contain a lowercase letter',
        () {
          // Arrange
          const input = 'NOPASSWORD123@';

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
        'when the input does not contain a special character',
        () {
          // Arrange
          const input = 'NoSpecialCharacter123A';

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
