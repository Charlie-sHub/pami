import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';

void main() {
  group(
    'Testing on success',
    () {
      const validLongitude = 90.0;
      const limitLongitude = Longitude.limit;
      const zeroLongitude = 0.0;
      const negativeLongitude = -90.0;
      const negativeLimitLongitude = -Longitude.limit;
      final validLongitudeObject = Longitude(validLongitude);
      final limitLongitudeObject = Longitude(limitLongitude);
      final zeroLongitudeObject = Longitude(zeroLongitude);
      final negativeLongitudeObject = Longitude(negativeLongitude);
      final negativeLimitLongitudeObject = Longitude(negativeLimitLongitude);

      test(
        'should return a Longitude with the input value '
        'when the input is valid',
        () {
          // Assert
          expect(validLongitudeObject.value, right(validLongitude));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is at the positive limit',
        () {
          // Assert
          expect(limitLongitudeObject.value, right(limitLongitude));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is 0',
        () {
          // Assert
          expect(zeroLongitudeObject.value, right(zeroLongitude));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is negative',
        () {
          // Assert
          expect(negativeLongitudeObject.value, right(negativeLongitude));
        },
      );

      test(
        'should return a Longitude with the input value '
        'when the input is at the negative limit',
        () {
          // Assert
          expect(
            negativeLimitLongitudeObject.value,
            right(negativeLimitLongitude),
          );
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      const overLimitLongitude = Longitude.limit + 0.1;
      const underNegativeLimitLongitude = -Longitude.limit - 0.1;
      final overLimitLongitudeObject = Longitude(overLimitLongitude);
      final underNegativeLimitLongitudeObject = Longitude(
        underNegativeLimitLongitude,
      );

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the positive limit',
        () {
          // Assert
          expect(
            overLimitLongitudeObject.value,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: overLimitLongitude,
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
            underNegativeLimitLongitudeObject.value,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: underNegativeLimitLongitude,
              ),
            ),
          );
        },
      );
    },
  );
}
