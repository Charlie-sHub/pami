import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/password_confirmator.dart';

void main() {
  const validPassword = 'password123';
  const validConfirmation = 'password123';
  const mismatchedConfirmation = 'differentPassword';
  const emptyPassword = '';
  const emptyConfirmation = '';

  group(
    'Testing on success',
    () {
      final validPasswordConfirmator = PasswordConfirmator(
        password: validPassword,
        confirmation: validConfirmation,
      );

      test(
        'should return a PasswordConfirmator with the input value '
        'when the password and confirmation match',
        () {
          // Assert
          expect(validPasswordConfirmator.value, right(validConfirmation));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      final mismatchedPasswordConfirmator = PasswordConfirmator(
        password: validPassword,
        confirmation: mismatchedConfirmation,
      );
      final emptyPasswordConfirmator = PasswordConfirmator(
        password: emptyPassword,
        confirmation: emptyConfirmation,
      );
      final emptyConfirmationConfirmator = PasswordConfirmator(
        password: emptyPassword,
        confirmation: emptyConfirmation,
      );

      test(
        'should return a Failure.stringMismatch '
        'when the password and confirmation do not match',
        () {
          // Assert
          expect(
            mismatchedPasswordConfirmator.value,
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
          // Assert
          expect(
            emptyPasswordConfirmator.value,
            left(
              const Failure<String>.emptyString(failedValue: emptyConfirmation),
            ),
          );
        },
      );

      test(
        'should return a Failure.emptyString when the confirmation is empty',
        () {
          // Assert
          expect(
            emptyConfirmationConfirmator.value,
            left(
              const Failure<String>.emptyString(failedValue: emptyConfirmation),
            ),
          );
        },
      );
    },
  );
}
