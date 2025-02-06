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
          const input = 'test@example.com';

          // Act
          final result = EmailAddress(input);

          // Assert
          expect(result.value, right(input));
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
          const input = 'not a valid email';

          // Act
          final result = EmailAddress(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.invalidEmail(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidEmail '
        'when the input is an empty string',
        () {
          // Arrange
          const input = '';

          // Act
          final result = EmailAddress(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.invalidEmail(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
