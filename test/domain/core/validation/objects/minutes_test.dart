import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';

void main() {
  late Minutes validMinutesObject;
  late Minutes limitMinutesObject;
  late Minutes zeroMinutesObject;
  late Minutes overLimitMinutesObject;
  late Minutes negativeMinutesObject;

  setUp(
    () {
      // Arrange
      const validMinutes = 720.0;
      const limitMinutes = Minutes.limit;
      const zeroMinutes = 0.0;
      const overLimitMinutes = Minutes.limit + 0.1;
      const negativeMinutes = -1.0;

      validMinutesObject = Minutes(validMinutes);
      limitMinutesObject = Minutes(limitMinutes);
      zeroMinutesObject = Minutes(zeroMinutes);
      overLimitMinutesObject = Minutes(overLimitMinutes);
      negativeMinutesObject = Minutes(negativeMinutes);
    },
  );

  group(
    'Testing on success',
    () {
      test(
        'should return a Minutes with the input value '
        'when the input is valid',
        () {
          // Act
          final result = validMinutesObject.value;

          // Assert
          expect(result, right(720));
        },
      );

      test(
        'should return a Minutes with the input value '
        'when the input is at the limit',
        () {
          // Act
          final result = limitMinutesObject.value;

          // Assert
          expect(result, right(Minutes.limit));
        },
      );

      test(
        'should return a Minutes with the input value when the input is 0',
        () {
          // Act
          final result = zeroMinutesObject.value;

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
          final result = overLimitMinutesObject.value;

          // Assert
          expect(
            result,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: Minutes.limit + 0.1,
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
          final result = negativeMinutesObject.value;

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
