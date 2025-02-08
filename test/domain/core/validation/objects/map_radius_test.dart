import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

void main() {
  group(
    'Testing on success',
    () {
      const validRadius = 10.0;
      const limitRadius = MapRadius.limit;
      const zeroRadius = 0.0;
      final validMapRadius = MapRadius(validRadius);
      final limitMapRadius = MapRadius(limitRadius);
      final zeroMapRadius = MapRadius(zeroRadius);

      test(
        'should return a Radius with the input value when the input is valid',
        () {
          // Assert
          expect(validMapRadius.value, right(validRadius));
        },
      );

      test(
        'should return a Radius with the input value '
        'when the input is at the limit',
        () {
          // Assert
          expect(limitMapRadius.value, right(limitRadius));
        },
      );

      test(
        'should return a Radius with the input value when the input is 0',
        () {
          // Assert
          expect(zeroMapRadius.value, right(zeroRadius));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      const overLimitRadius = MapRadius.limit + 0.1;
      const negativeRadius = -1.0;
      final overLimitMapRadius = MapRadius(overLimitRadius);
      final negativeMapRadius = MapRadius(negativeRadius);

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the limit',
        () {
          // Assert
          expect(
            overLimitMapRadius.value,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: overLimitRadius,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.doubleOutOfBounds when the input is negative',
        () {
          // Assert
          expect(
            negativeMapRadius.value,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: negativeRadius,
              ),
            ),
          );
        },
      );
    },
  );
}
