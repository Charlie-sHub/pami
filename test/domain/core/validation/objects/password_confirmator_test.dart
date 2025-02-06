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
          const password = 'password123';
          const confirmation = 'password123';

          // Act
          final result = PasswordConfirmator(
            password: password,
            confirmation: confirmation,
          );

          // Assert
          expect(result.value, right(confirmation));
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
          const password = 'password123';
          const confirmation = 'differentPassword';

          // Act
          final result = PasswordConfirmator(
            password: password,
            confirmation: confirmation,
          );

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.stringMismatch(failedValue: confirmation),
            ),
          );
        },
      );

      test(
        'should return a Failure.emptyString when the password is empty',
        () {
          // Arrange
          const password = '';
          const confirmation = '';

          // Act
          final result = PasswordConfirmator(
            password: password,
            confirmation: confirmation,
          );

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.emptyString(failedValue: confirmation),
            ),
          );
        },
      );

      test(
        'should return a Failure.emptyString when the confirmation is empty',
        () {
          // Arrange
          const password = '';
          const confirmation = '';

          // Act
          final result = PasswordConfirmator(
            password: password,
            confirmation: confirmation,
          );

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.emptyString(failedValue: confirmation),
            ),
          );
        },
      );
    },
  );
}
