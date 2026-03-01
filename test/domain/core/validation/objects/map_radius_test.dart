import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a Radius with the input value '
        'when the input is valid',
        () {
          // Arrange
          const validRadius = 10.0;
          final validMapRadius = MapRadius(validRadius);

          // Act
          final result = validMapRadius.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(10));
        },
      );

      test(
        'should return a Radius with the input value '
        'when the input is at the limit',
        () {
          // Arrange
          const limitRadius = MapRadius.limit;
          final limitMapRadius = MapRadius(limitRadius);

          // Act
          final result = limitMapRadius.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(MapRadius.limit));
        },
      );

      test(
        'should return a Radius with the input value '
        'when the input is 0',
        () {
          // Arrange
          const zeroRadius = 0.0;
          final zeroMapRadius = MapRadius(zeroRadius);

          // Act
          final result = zeroMapRadius.value;

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
          const overLimitRadius = MapRadius.limit + 0.1;
          final overLimitMapRadius = MapRadius(overLimitRadius);

          // Act
          final result = overLimitMapRadius.value;

          // Assert
          expect(
            result,
            left<ValueFailure<double>, double>(
              const ValueFailure<double>.doubleOutOfBounds(
                failedValue: MapRadius.limit + 0.1,
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
          const negativeRadius = -1.0;
          final negativeMapRadius = MapRadius(negativeRadius);

          // Act
          final result = negativeMapRadius.value;

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
