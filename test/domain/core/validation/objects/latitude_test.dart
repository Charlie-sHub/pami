import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';

void main() {
  group(
    'Testing on success',
    () {
      const validLatitude = 45.0;
      const limitLatitude = Latitude.limit;
      const zeroLatitude = 0.0;
      const negativeLatitude = -45.0;
      const negativeLimitLatitude = -Latitude.limit;
      final validLatitudeObject = Latitude(validLatitude);
      final limitLatitudeObject = Latitude(limitLatitude);
      final zeroLatitudeObject = Latitude(zeroLatitude);
      final negativeLatitudeObject = Latitude(negativeLatitude);
      final negativeLimitLatitudeObject = Latitude(negativeLimitLatitude);

      test(
        'should return a Latitude with the input value when the input is valid',
        () {
          // Assert
          expect(validLatitudeObject.value, right(validLatitude));
        },
      );

      test(
        'should return a Latitude with the input value '
        'when the input is at the limit',
        () {
          // Assert
          expect(limitLatitudeObject.value, right(limitLatitude));
        },
      );

      test(
        'should return a Latitude with the input value when the input is 0',
        () {
          // Assert
          expect(zeroLatitudeObject.value, right(zeroLatitude));
        },
      );

      test(
        'should return a Latitude with the input value '
        'when the input is negative',
        () {
          // Assert
          expect(negativeLatitudeObject.value, right(negativeLatitude));
        },
      );

      test(
        'should return a Latitude with the input value '
        'when the input is at the negative limit',
        () {
          // Assert
          expect(
            negativeLimitLatitudeObject.value,
            right(negativeLimitLatitude),
          );
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      const overLimitLatitude = Latitude.limit + 0.1;
      const underNegativeLimitLatitude = -Latitude.limit - 0.1;
      final overLimitLatitudeObject = Latitude(overLimitLatitude);
      final underNegativeLimitLatitudeObject = Latitude(
        underNegativeLimitLatitude,
      );

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the positive limit',
        () {
          // Assert
          expect(
            overLimitLatitudeObject.value,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: overLimitLatitude,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the negative limit',
        () {
          // Assert
          expect(
            underNegativeLimitLatitudeObject.value,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: underNegativeLimitLatitude,
              ),
            ),
          );
        },
      );
    },
  );
}
