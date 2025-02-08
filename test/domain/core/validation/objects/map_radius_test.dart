import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

void main() {
  late MapRadius validMapRadius;
  late MapRadius limitMapRadius;
  late MapRadius zeroMapRadius;
  late MapRadius overLimitMapRadius;
  late MapRadius negativeMapRadius;

  setUp(
    () {
      // Arrange
      const validRadius = 10.0;
      const limitRadius = MapRadius.limit;
      const zeroRadius = 0.0;
      const overLimitRadius = MapRadius.limit + 0.1;
      const negativeRadius = -1.0;

      validMapRadius = MapRadius(validRadius);
      limitMapRadius = MapRadius(limitRadius);
      zeroMapRadius = MapRadius(zeroRadius);
      overLimitMapRadius = MapRadius(overLimitRadius);
      negativeMapRadius = MapRadius(negativeRadius);
    },
  );

  group(
    'Testing on success',
    () {
      test(
        'should return a Radius with the input value '
        'when the input is valid',
        () {
          // Act
          final result = validMapRadius.value;

          // Assert
          expect(result, right(10));
        },
      );

      test(
        'should return a Radius with the input value '
        'when the input is at the limit',
        () {
          // Act
          final result = limitMapRadius.value;

          // Assert
          expect(result, right(MapRadius.limit));
        },
      );

      test(
        'should return a Radius with the input value '
        'when the input is 0',
        () {
          // Act
          final result = zeroMapRadius.value;

          // Assert
          expect(result, right(0));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the limit',
        () {
          // Act
          final result = overLimitMapRadius.value;

          // Assert
          expect(
            result,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: MapRadius.limit + 0.1,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input is negative',
        () {
          // Act
          final result = negativeMapRadius.value;

          // Assert
          expect(
            result,
            left(
              const Failure<double>.doubleOutOfBounds(failedValue: -1),
            ),
          );
        },
      );
    },
  );
}
