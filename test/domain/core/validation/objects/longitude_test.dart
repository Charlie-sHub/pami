import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a Longitude with the input value '
        'when the input is valid',
        () {
          // Arrange
          const input = 90.0;

          // Act
          final result = Longitude(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is at the positive limit',
        () {
          // Arrange
          const input = Longitude.limit;

          // Act
          final result = Longitude(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is 0',
        () {
          // Arrange
          const input = 0.0;

          // Act
          final result = Longitude(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is negative',
        () {
          // Arrange
          const input = -90.0;

          // Act
          final result = Longitude(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is at the negative limit',
        () {
          // Arrange
          const input = -Longitude.limit;

          // Act
          final result = Longitude(input);

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
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the positive limit',
        () {
          // Arrange
          const input = Longitude.limit + 0.1;

          // Act
          final result = Longitude(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<double>.doubleOutOfBounds(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the negative limit',
        () {
          // Arrange
          const input = -Longitude.limit - 0.1;

          // Act
          final result = Longitude(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<double>.doubleOutOfBounds(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
