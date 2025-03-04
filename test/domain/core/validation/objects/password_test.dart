import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/password.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a Password with the input value '
        'when the input is a valid password',
        () {
          // Arrange
          const validPassword = 'ValidP@sswOrd123';
          final password = Password(validPassword);

          // Act
          final result = password.value;

          // Assert
          expect(result, right(validPassword));
        },
      );

      test(
        'should return a Password with the input value '
        'when the input is a valid password with special characters',
        () {
          // Arrange
          const validPasswordWithSpecialChars = r'V@l!dP@$$wOrd123#';
          final password = Password(validPasswordWithSpecialChars);

          // Act
          final result = password.value;

          // Assert
          expect(result, right(validPasswordWithSpecialChars));
        },
      );

      test(
        'should return a Password with the input value '
        'when the input is a valid password with more special characters',
        () {
          // Arrange
          const validPasswordWithMoreSpecialChars = r'V@l!dP@$$wOrd123#$&';
          final password = Password(validPasswordWithMoreSpecialChars);

          // Act
          final result = password.value;

          // Assert
          expect(result, right(validPasswordWithMoreSpecialChars));
        },
      );

      test(
        'should return a Password with the input value '
        'when the input is a valid password with more numbers',
        () {
          // Arrange
          const validPasswordWithMoreNumbers = r'V@l!dP@$$wOrd123456789#';
          final password = Password(validPasswordWithMoreNumbers);

          // Act
          final result = password.value;

          // Assert
          expect(result, right(validPasswordWithMoreNumbers));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.emptyString '
        'when the input is an empty string',
        () {
          // Arrange
          const emptyPassword = '';
          final password = Password(emptyPassword);

          // Act
          final result = password.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.emptyString(
                failedValue: emptyPassword,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidPassword when the input '
        'is longer than the max length',
        () {
          // Arrange
          final tooLongString = 'a' * (Password.maxLength + 1);
          final password = Password(tooLongString);

          // Act
          final result = password.value;

          // Assert
          expect(
            result,
            left(
              Failure<String>.invalidPassword(
                failedValue: tooLongString,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidPassword '
        'when the input is too short',
        () {
          // Arrange
          const shortPassword = 'Short1@';
          final password = Password(shortPassword);

          // Act
          final result = password.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.invalidPassword(
                failedValue: shortPassword,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidPassword '
        'when the input does not contain a number',
        () {
          // Arrange
          const noNumberPassword = 'NoNumberPassword@';
          final password = Password(noNumberPassword);

          // Act
          final result = password.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.invalidPassword(
                failedValue: noNumberPassword,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidPassword '
        'when the input does not contain an uppercase letter',
        () {
          // Arrange
          const noUppercasePassword = 'nopassword123@';
          final password = Password(noUppercasePassword);

          // Act
          final result = password.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.invalidPassword(
                failedValue: noUppercasePassword,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidPassword '
        'when the input does not contain a lowercase letter',
        () {
          // Arrange
          const noLowercasePassword = 'NOPASSWORD123@';
          final password = Password(noLowercasePassword);

          // Act
          final result = password.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.invalidPassword(
                failedValue: noLowercasePassword,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.multiLineString '
        'when the input contains multiple lines',
        () {
          // Arrange
          const multiLinePassword = 'Password\n123@';
          final password = Password(multiLinePassword);

          // Act
          final result = password.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.multiLineString(
                failedValue: multiLinePassword,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidPassword '
        'when the input does not contain a special character',
        () {
          // Arrange
          const noSpecialCharPassword = 'NoSpecialCharacter123A';
          final password = Password(noSpecialCharPassword);

          // Act
          final result = password.value;

          // Assert
          expect(
            result,
            left(
              const Failure<String>.invalidPassword(
                failedValue: noSpecialCharPassword,
              ),
            ),
          );
        },
      );
    },
  );
}
