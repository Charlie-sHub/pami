import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';

void main() {
  group(
    'Testing on success',
    () {
      const validMinutes = 720.0;
      const limitMinutes = Minutes.limit;
      const zeroMinutes = 0.0;
      final validMinutesObject = Minutes(validMinutes);
      final limitMinutesObject = Minutes(limitMinutes);
      final zeroMinutesObject = Minutes(zeroMinutes);

      test(
        'should return a Minutes with the input value when the input is valid',
        () {
          // Assert
          expect(validMinutesObject.value, right(validMinutes));
        },
      );

      test(
        'should return a Minutes with the input value '
        'when the input is at the limit',
        () {
          // Assert
          expect(limitMinutesObject.value, right(limitMinutes));
        },
      );

      test(
        'should return a Minutes with the input value when the input is 0',
        () {
          // Assert
          expect(zeroMinutesObject.value, right(zeroMinutes));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      const overLimitMinutes = Minutes.limit + 0.1;
      const negativeMinutes = -1.0;
      final overLimitMinutesObject = Minutes(overLimitMinutes);
      final negativeMinutesObject = Minutes(negativeMinutes);

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the limit',
        () {
          // Assert
          expect(
            overLimitMinutesObject.value,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: overLimitMinutes,
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
            negativeMinutesObject.value,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: negativeMinutes,
              ),
            ),
          );
        },
      );
    },
  );
}
