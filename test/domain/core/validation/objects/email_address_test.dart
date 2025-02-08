import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return an EmailAddress with the input value '
        'when the input is a valid email',
        () {
          // Arrange
          const validEmail = 'test@example.com';
          final validEmailAddress = EmailAddress(validEmail);

          // Act
          final result = validEmailAddress.value;

          // Assert
          expect(result, right(validEmail));
        },
      );

      test(
        'should return an EmailAddress with the input value '
        'when the input is a valid email with a subdomain',
        () {
          // Arrange
          const validEmail = 'test@subdomain.example.com';
          final validEmailAddress = EmailAddress(validEmail);

          // Act
          final result = validEmailAddress.value;

          // Assert
          expect(result, right(validEmail));
        },
      );

      test(
        'should return an EmailAddress with the input value '
        'when the input is a valid email with a plus sign',
        () {
          // Arrange
          const validEmail = 'test+alias@example.com';
          final validEmailAddress = EmailAddress(validEmail);

          // Act
          final result = validEmailAddress.value;

          // Assert
          expect(result, right(validEmail));
        },
      );

      test(
        'should return an EmailAddress with the input value '
        'when the input is a valid email with numbers',
        () {
          // Arrange
          const validEmail = 'test1234@example.com';
          final validEmailAddress = EmailAddress(validEmail);

          // Act
          final result = validEmailAddress.value;

          // Assert
          expect(result, right(validEmail));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.invalidEmail '
        'when the input is not a valid email',
        () {
          // Arrange
          const invalidEmail = 'not a valid email';
          final invalidEmailAddress = EmailAddress(invalidEmail);

          // Act
          final result = invalidEmailAddress.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.invalidEmail(failedValue: invalidEmail),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidEmail '
        'when the input is an empty string',
        () {
          // Arrange
          const emptyEmail = '';
          final emptyEmailAddress = EmailAddress(emptyEmail);

          // Act
          final result = emptyEmailAddress.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.invalidEmail(failedValue: emptyEmail),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidEmail '
        'when the input is missing the @ symbol',
        () {
          // Arrange
          const invalidEmail = 'testexample.com';
          final invalidEmailAddress = EmailAddress(invalidEmail);

          // Act
          final result = invalidEmailAddress.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.invalidEmail(failedValue: invalidEmail),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidEmail '
        'when the input is missing the domain',
        () {
          // Arrange
          const invalidEmail = 'test@';
          final invalidEmailAddress = EmailAddress(invalidEmail);

          // Act
          final result = invalidEmailAddress.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.invalidEmail(failedValue: invalidEmail),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidEmail '
        'when the input is missing the username',
        () {
          // Arrange
          const invalidEmail = '@example.com';
          final invalidEmailAddress = EmailAddress(invalidEmail);

          // Act
          final result = invalidEmailAddress.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.invalidEmail(failedValue: invalidEmail),
            ),
          );
        },
      );
    },
  );
}
