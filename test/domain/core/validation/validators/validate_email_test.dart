import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_email.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input email when it is valid',
        () {
          // Arrange
          const input = 'test@example.com';

          // Act
          final result = validateEmail(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input email when it is valid with subdomains',
        () {
          // Arrange
          const input = 'test@sub.example.com';

          // Act
          final result = validateEmail(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input email when it is valid with numbers',
        () {
          // Arrange
          const input = 'test1234@example.com';

          // Act
          final result = validateEmail(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input email '
        'when it is valid with special characters',
        () {
          // Arrange
          const input = 'test.test-test_test@example.com';

          // Act
          final result = validateEmail(input);

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
        'should return a Failure.invalidEmail when the input is empty',
        () {
          // Arrange
          const input = '';

          // Act
          final result = validateEmail(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidEmail(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidEmail when the input is not an email',
        () {
          // Arrange
          const input = 'not an email';

          // Act
          final result = validateEmail(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidEmail(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidEmail when the input is missing the @',
        () {
          // Arrange
          const input = 'testexample.com';

          // Act
          final result = validateEmail(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidEmail(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidEmail '
        'when the input is missing the domain',
        () {
          // Arrange
          const input = 'test@';

          // Act
          final result = validateEmail(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidEmail(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidEmail '
        'when the input is missing the top level domain',
        () {
          // Arrange
          const input = 'test@example';

          // Act
          final result = validateEmail(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidEmail(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
