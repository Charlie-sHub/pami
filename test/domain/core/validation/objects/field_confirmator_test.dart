import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/field_confirmator.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a FieldConfirmator with the input value '
        'when the password and confirmation match',
        () {
          // Arrange
          const password = 'password123';
          const validConfirmation = 'password123';
          final validFieldConfirmator = FieldConfirmator(
            field: password,
            confirmation: validConfirmation,
          );

          // Act
          final result = validFieldConfirmator.value;

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
          final mismatchedFieldConfirmator = FieldConfirmator(
            field: validPassword,
            confirmation: mismatchedConfirmation,
          );

          // Act
          final result = mismatchedFieldConfirmator.value;

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
          final emptyFieldConfirmator = FieldConfirmator(
            field: emptyPassword,
            confirmation: emptyConfirmation,
          );

          // Act
          final result = emptyFieldConfirmator.value;

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
          final emptyConfirmationConfirmator = FieldConfirmator(
            field: emptyPassword,
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
