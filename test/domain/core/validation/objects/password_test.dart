import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/password.dart';

void main() {
  group('Testing on success', () {
    const validPassword = 'ValidP@sswOrd123';
    const validPasswordWithSpecialChars = r'V@l!dP@$$wOrd123#';
    const validPasswordWithMoreSpecialChars = r'V@l!dP@$$wOrd123#$&';
    const validPasswordWithMoreNumbers = r'V@l!dP@$$wOrd123456789#';

    test(
      'should return a Password with the input value '
      'when the input is a valid password',
      () {
        final result = Password(validPassword);
        expect(result.value, right(validPassword));
      },
    );

    test(
      'should return a Password with the input value '
      'when the input is a valid password with special characters',
      () {
        final result = Password(validPasswordWithSpecialChars);
        expect(result.value, right(validPasswordWithSpecialChars));
      },
    );

    test(
      'should return a Password with the input value '
      'when the input is a valid password with more special characters',
      () {
        final result = Password(validPasswordWithMoreSpecialChars);
        expect(result.value, right(validPasswordWithMoreSpecialChars));
      },
    );

    test(
      'should return a Password with the input value '
      'when the input is a valid password with more numbers',
      () {
        final result = Password(validPasswordWithMoreNumbers);
        expect(result.value, right(validPasswordWithMoreNumbers));
      },
    );
  });

  group('Testing on failure', () {
    const emptyPassword = '';
    const shortPassword = 'Short1@';
    const noNumberPassword = 'NoNumberPassword@';
    const noUppercasePassword = 'nopassword123@';
    const noLowercasePassword = 'NOPASSWORD123@';
    const multiLinePassword = 'Password\n123@';
    const noSpecialCharPassword = 'NoSpecialCharacter123A';

    test(
        'should return a Failure.emptyString when the input is an empty string',
        () {
      final result = Password(emptyPassword);
      expect(
        result.value,
        left(const Failure<String>.emptyString(failedValue: emptyPassword)),
      );
    });

    test('should return a Failure.invalidPassword when the input is too short',
        () {
      final result = Password(shortPassword);
      expect(
        result.value,
        left(const Failure<String>.invalidPassword(failedValue: shortPassword)),
      );
    });

    test(
        'should return a Failure.invalidPassword '
        'when the input does not contain a number', () {
      final result = Password(noNumberPassword);
      expect(
        result.value,
        left(
          const Failure<String>.invalidPassword(
            failedValue: noNumberPassword,
          ),
        ),
      );
    });

    test(
        'should return a Failure.invalidPassword '
        'when the input does not contain an uppercase letter', () {
      final result = Password(noUppercasePassword);
      expect(
        result.value,
        left(
          const Failure<String>.invalidPassword(
            failedValue: noUppercasePassword,
          ),
        ),
      );
    });

    test(
        'should return a Failure.invalidPassword '
        'when the input does not contain a lowercase letter', () {
      final result = Password(noLowercasePassword);
      expect(
        result.value,
        left(
          const Failure<String>.invalidPassword(
            failedValue: noLowercasePassword,
          ),
        ),
      );
    });

    test(
        'should return a Failure.multiLineString '
        'when the input contains multiple lines', () {
      final result = Password(multiLinePassword);
      expect(
        result.value,
        left(
          const Failure<String>.multiLineString(
            failedValue: multiLinePassword,
          ),
        ),
      );
    });

    test(
        'should return a Failure.invalidPassword '
        'when the input does not contain a special character', () {
      final result = Password(noSpecialCharPassword);
      expect(
        result.value,
        left(
          const Failure<String>.invalidPassword(
            failedValue: noSpecialCharPassword,
          ),
        ),
      );
    });
  });
}
