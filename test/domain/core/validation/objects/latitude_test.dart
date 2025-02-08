import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';

void main() {
  late Latitude validLatitudeObject;
  late Latitude limitLatitudeObject;
  late Latitude zeroLatitudeObject;
  late Latitude negativeLatitudeObject;
  late Latitude negativeLimitLatitudeObject;
  late Latitude overLimitLatitudeObject;
  late Latitude underNegativeLimitLatitudeObject;

  setUp(
    () {
      // Arrange
      const validLatitude = 45.0;
      const limitLatitude = Latitude.limit;
      const zeroLatitude = 0.0;
      const negativeLatitude = -45.0;
      const negativeLimitLatitude = -Latitude.limit;
      const overLimitLatitude = Latitude.limit + 0.1;
      const underNegativeLimitLatitude = -Latitude.limit - 0.1;

      validLatitudeObject = Latitude(validLatitude);
      limitLatitudeObject = Latitude(limitLatitude);
      zeroLatitudeObject = Latitude(zeroLatitude);
      negativeLatitudeObject = Latitude(negativeLatitude);
      negativeLimitLatitudeObject = Latitude(negativeLimitLatitude);
      overLimitLatitudeObject = Latitude(overLimitLatitude);
      underNegativeLimitLatitudeObject = Latitude(underNegativeLimitLatitude);
    },
  );

  group(
    'Testing on success',
    () {
      test(
        'should return a Latitude with the input value '
        'when the input is valid',
        () {
          // Act
          final result = validLatitudeObject.value;

          // Assert
          expect(result, right(45));
        },
      );

      test(
        'should return a Latitude with the input value '
        'when the input is at the limit',
        () {
          // Act
          final result = limitLatitudeObject.value;

          // Assert
          expect(result, right(Latitude.limit));
        },
      );

      test(
        'should return a Latitude with the input value when the input is 0',
        () {
          // Act
          final result = zeroLatitudeObject.value;

          // Assert
          expect(result, right(0));
        },
      );

      test(
        'should return a Latitude with the input value '
        'when the input is negative',
        () {
          // Act
          final result = negativeLatitudeObject.value;

          // Assert
          expect(result, right(-45));
        },
      );

      test(
        'should return a Latitude with the input value '
        'when the input is at the negative limit',
        () {
          // Act
          final result = negativeLimitLatitudeObject.value;

          // Assert
          expect(result, right(-Latitude.limit));
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
          // Act
          final result = overLimitLatitudeObject.value;

          // Assert
          expect(
            result,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: Latitude.limit + 0.1,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the negative limit',
        () {
          // Act
          final result = underNegativeLimitLatitudeObject.value;

          // Assert
          expect(
            result,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: -Latitude.limit - 0.1,
              ),
            ),
          );
        },
      );
    },
  );
}
