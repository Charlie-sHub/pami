import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';

void main() {
  group(
    'Testing on success',
    () {
      const validEmail = 'test@example.com';
      final validEmailAddress = EmailAddress(validEmail);

      test(
        'should return an EmailAddress with the input value '
        'when the input is a valid email',
        () {
          // Assert
          expect(validEmailAddress.value, right(validEmail));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      const invalidEmail = 'not a valid email';
      const emptyEmail = '';
      final invalidEmailAddress = EmailAddress(invalidEmail);
      final emptyEmailAddress = EmailAddress(emptyEmail);

      test(
        'should return a Failure.invalidEmail '
        'when the input is not a valid email',
        () {
          // Assert
          expect(
            invalidEmailAddress.value,
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
          // Assert
          expect(
            emptyEmailAddress.value,
            left(
              const Failure<String>.invalidEmail(failedValue: emptyEmail),
            ),
          );
        },
      );
    },
  );
}
