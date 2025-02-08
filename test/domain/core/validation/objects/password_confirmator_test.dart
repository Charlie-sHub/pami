import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/password_confirmator.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a PasswordConfirmator with the input value '
        'when the password and confirmation match',
        () {
          // Arrange
          const validPassword = 'password123';
          const validConfirmation = 'password123';
          final validPasswordConfirmator = PasswordConfirmator(
            password: validPassword,
            confirmation: validConfirmation,
          );

          // Act
          final result = validPasswordConfirmator.value;

          // Assert
          expect(result, right(validConfirmation));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.stringMismatch '
        'when the password and confirmation do not match',
        () {
          // Arrange
          const validPassword = 'password123';
          const mismatchedConfirmation = 'differentPassword';
          final mismatchedPasswordConfirmator = PasswordConfirmator(
            password: validPassword,
            confirmation: mismatchedConfirmation,
          );

          // Act
          final result = mismatchedPasswordConfirmator.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.stringMismatch(
                failedValue: mismatchedConfirmation,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.emptyString when the password is empty',
        () {
          // Arrange
          const emptyPassword = '';
          const emptyConfirmation = '';
          final emptyPasswordConfirmator = PasswordConfirmator(
            password: emptyPassword,
            confirmation: emptyConfirmation,
          );

          // Act
          final result = emptyPasswordConfirmator.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.emptyString(
                failedValue: emptyConfirmation,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.emptyString '
        'when the confirmation is empty',
        () {
          // Arrange
          const emptyPassword = '';
          const emptyConfirmation = '';
          final emptyConfirmationConfirmator = PasswordConfirmator(
            password: emptyPassword,
            confirmation: emptyConfirmation,
          );

          // Act
          final result = emptyConfirmationConfirmator.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.emptyString(
                failedValue: emptyConfirmation,
              ),
            ),
          );
        },
      );
    },
  );
}
