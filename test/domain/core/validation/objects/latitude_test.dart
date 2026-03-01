import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a Latitude with the input value '
        'when the input is valid',
        () {
          // Arrange
          const validLatitude = 45.0;
          final validLatitudeObject = Latitude(validLatitude);

          // Act
          final result = validLatitudeObject.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(45));
        },
      );

      test(
        'should return a Latitude with the input value '
        'when the input is at the limit',
        () {
          // Arrange
          const limitLatitude = Latitude.limit;
          final limitLatitudeObject = Latitude(limitLatitude);

          // Act
          final result = limitLatitudeObject.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(Latitude.limit));
        },
      );

      test(
        'should return a Latitude with the input value when the input is 0',
        () {
          // Arrange
          const zeroLatitude = 0.0;
          final zeroLatitudeObject = Latitude(zeroLatitude);

          // Act
          final result = zeroLatitudeObject.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(0));
        },
      );

      test(
        'should return a Latitude with the input value '
        'when the input is negative',
        () {
          // Arrange
          const negativeLatitude = -45.0;
          final negativeLatitudeObject = Latitude(negativeLatitude);

          // Act
          final result = negativeLatitudeObject.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(-45));
        },
      );

      test(
        'should return a Latitude with the input value '
        'when the input is at the negative limit',
        () {
          // Arrange
          const negativeLimitLatitude = -Latitude.limit;
          final negativeLimitLatitudeObject = Latitude(negativeLimitLatitude);

          // Act
          final result = negativeLimitLatitudeObject.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(-Latitude.limit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a ValueFailure.doubleOutOfBounds '
        'when the input exceeds the positive limit',
        () {
          // Arrange
          const overLimitLatitude = Latitude.limit + 0.1;
          final overLimitLatitudeObject = Latitude(overLimitLatitude);

          // Act
          final result = overLimitLatitudeObject.value;

          // Assert
          expect(
            result,
            left<ValueFailure<double>, double>(
              const ValueFailure<double>.doubleOutOfBounds(
                failedValue: Latitude.limit + 0.1,
              ),
            ),
          );
        },
      );

      test(
        'should return a ValueFailure.doubleOutOfBounds '
        'when the input exceeds the negative limit',
        () {
          // Arrange
          const underNegativeLimitLatitude = -Latitude.limit - 0.1;
          final underNegativeLimitLatitudeObject = Latitude(
            underNegativeLimitLatitude,
          );

          // Act
          final result = underNegativeLimitLatitudeObject.value;

          // Assert
          expect(
            result,
            left<ValueFailure<double>, double>(
              const ValueFailure<double>.doubleOutOfBounds(
                failedValue: -Latitude.limit - 0.1,
              ),
            ),
          );
        },
      );
    },
  );
}
