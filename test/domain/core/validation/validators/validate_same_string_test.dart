import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/validators/validate_same_string.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the first input string when both strings are the same',
        () {
          // Arrange
          const firstInput = 'test';
          const secondInput = 'test';

          // Act
          final result = validateSameString(firstInput, secondInput);

          // Assert
          expect(result, right<ValueFailure<String>, String>(firstInput));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a ValueFailure.stringMismatch '
        'when the strings are different',
        () {
          // Arrange
          const firstInput = 'test1';
          const secondInput = 'test2';

          // Act
          final result = validateSameString(firstInput, secondInput);

          // Assert
          expect(
            result,
            left<ValueFailure<String>, String>(
              const ValueFailure.stringMismatch(failedValue: secondInput),
            ),
          );
        },
      );
    },
  );
}
