import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';

void main() {
  late Longitude validLongitudeObject;
  late Longitude limitLongitudeObject;
  late Longitude zeroLongitudeObject;
  late Longitude negativeLongitudeObject;
  late Longitude negativeLimitLongitudeObject;
  late Longitude overLimitLongitudeObject;
  late Longitude underNegativeLimitLongitudeObject;

  setUp(
    () {
      // Arrange
      const validLongitude = 90.0;
      const limitLongitude = Longitude.limit;
      const zeroLongitude = 0.0;
      const negativeLongitude = -90.0;
      const negativeLimitLongitude = -Longitude.limit;
      const overLimitLongitude = Longitude.limit + 0.1;
      const underNegativeLimitLongitude = -Longitude.limit - 0.1;

      validLongitudeObject = Longitude(validLongitude);
      limitLongitudeObject = Longitude(limitLongitude);
      zeroLongitudeObject = Longitude(zeroLongitude);
      negativeLongitudeObject = Longitude(negativeLongitude);
      negativeLimitLongitudeObject = Longitude(negativeLimitLongitude);
      overLimitLongitudeObject = Longitude(overLimitLongitude);
      underNegativeLimitLongitudeObject = Longitude(
        underNegativeLimitLongitude,
      );
    },
  );

  group(
    'Testing on success',
    () {
      test(
        'should return a Longitude with the input value '
        'when the input is valid',
        () {
          // Act
          final result = validLongitudeObject.value;

          // Assert
          expect(result, right(90));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is at the positive limit',
        () {
          // Act
          final result = limitLongitudeObject.value;

          // Assert
          expect(result, right(Longitude.limit));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is 0',
        () {
          // Act
          final result = zeroLongitudeObject.value;

          // Assert
          expect(result, right(0));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is negative',
        () {
          // Act
          final result = negativeLongitudeObject.value;

          // Assert
          expect(result, right(-90));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is at the negative limit',
        () {
          // Act
          final result = negativeLimitLongitudeObject.value;

          // Assert
          expect(result, right(-Longitude.limit));
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
          final result = overLimitLongitudeObject.value;

          // Assert
          expect(
            result,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: Longitude.limit + 0.1,
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
          final result = underNegativeLimitLongitudeObject.value;

          // Assert
          expect(
            result,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: -Longitude.limit - 0.1,
              ),
            ),
          );
        },
      );
    },
  );
}
