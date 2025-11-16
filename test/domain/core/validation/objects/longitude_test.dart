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
          const validLongitude = 90.0;
          final validLongitudeObject = Longitude(validLongitude);

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
          // Arrange
          const limitLongitude = Longitude.limit;
          final limitLongitudeObject = Longitude(limitLongitude);

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
          // Arrange
          const zeroLongitude = 0.0;
          final zeroLongitudeObject = Longitude(zeroLongitude);

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
          // Arrange
          const negativeLongitude = -90.0;
          final negativeLongitudeObject = Longitude(negativeLongitude);

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
          // Arrange
          const negativeLimitLongitude = -Longitude.limit;
          final negativeLimitLongitudeObject =
              Longitude(negativeLimitLongitude);

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
          // Arrange
          const overLimitLongitude = Longitude.limit + 0.1;
          final overLimitLongitudeObject = Longitude(overLimitLongitude);

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
          // Arrange
          const underNegativeLimitLongitude = -Longitude.limit - 0.1;
          final underNegativeLimitLongitudeObject =
              Longitude(underNegativeLimitLongitude);

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
