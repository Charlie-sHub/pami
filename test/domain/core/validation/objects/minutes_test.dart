import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a Minutes with the input value when the input is valid',
        () {
          // Arrange
          const input = 720.0;
          final minutes = Minutes(input);

          // Act
          final result = minutes.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(720));
        },
      );

      test(
        'should return a Minutes with the input value '
        'when the input is at the limit',
        () {
          // Arrange
          const input = Minutes.limit;
          final minutes = Minutes(input);

          // Act
          final result = minutes.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(Minutes.limit));
        },
      );

      test(
        'should return a Minutes with the input value when the input is 0',
        () {
          // Arrange
          const input = 0.0;
          final minutes = Minutes(input);

          // Act
          final result = minutes.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(0));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a ValueFailure.doubleOutOfBounds '
        'when the input exceeds the limit',
        () {
          // Arrange
          const input = Minutes.limit + 0.1;
          final minutes = Minutes(input);

          // Act
          final result = minutes.value;

          // Assert
          expect(
            result,
            left<ValueFailure<double>, double>(
              const ValueFailure<double>.doubleOutOfBounds(
                failedValue: Minutes.limit + 0.1,
              ),
            ),
          );
        },
      );

      test(
        'should return a ValueFailure.doubleOutOfBounds '
        'when the input is negative',
        () {
          // Arrange
          const input = -1.0;
          final minutes = Minutes(input);

          // Act
          final result = minutes.value;

          // Assert
          expect(
            result,
            left<ValueFailure<double>, double>(
              const ValueFailure<double>.doubleOutOfBounds(
                failedValue: -1,
              ),
            ),
          );
        },
      );
    },
  );
}
