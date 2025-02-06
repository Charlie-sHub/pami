import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_past_date.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input date when it is in the past',
        () {
          // Arrange
          final input = DateTime.now().subtract(const Duration(days: 1));

          // Act
          final result = validatePastDate(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input date when it is now',
        () {
          // Arrange
          final input = DateTime.now();

          // Act
          final result = validatePastDate(input);

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
        'should return a Failure.invalidDate '
        'when the input date is in the future',
        () {
          // Arrange
          final input = DateTime.now().add(const Duration(days: 1));

          // Act
          final result = validatePastDate(input);

          // Assert
          expect(
            result,
            left<Failure<DateTime>, DateTime>(
              Failure.invalidDate(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
