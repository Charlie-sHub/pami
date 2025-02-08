import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';

void main() {
  late KarmaPercentage validKarma;
  late KarmaPercentage limitKarma;
  late KarmaPercentage zeroKarma;
  late KarmaPercentage overLimitKarma;
  late KarmaPercentage negativeKarma;

  setUp(
    () {
      // Arrange
      const validKarmaPercentage = 50.0;
      const limitKarmaPercentage = KarmaPercentage.limit;
      const zeroKarmaPercentage = 0.0;
      const overLimitKarmaPercentage = KarmaPercentage.limit + 0.1;
      const negativeKarmaPercentage = -1.0;

      validKarma = KarmaPercentage(validKarmaPercentage);
      limitKarma = KarmaPercentage(limitKarmaPercentage);
      zeroKarma = KarmaPercentage(zeroKarmaPercentage);
      overLimitKarma = KarmaPercentage(overLimitKarmaPercentage);
      negativeKarma = KarmaPercentage(negativeKarmaPercentage);
    },
  );

  group(
    'Testing on success',
    () {
      test(
        'should return a KarmaPercentage with the input value '
        'when the input is valid',
        () {
          // Act
          final result = validKarma.value;

          // Assert
          expect(result, right(50));
        },
      );

      test(
        'should return a KarmaPercentage with the input value '
        'when the input is at the limit',
        () {
          // Act
          final result = limitKarma.value;

          // Assert
          expect(result, right(KarmaPercentage.limit));
        },
      );

      test(
        'should return a KarmaPercentage with the input value '
        'when the input is 0',
        () {
          // Act
          final result = zeroKarma.value;

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
          final result = overLimitKarma.value;

          // Assert
          expect(
            result,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: KarmaPercentage.limit + 0.1,
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
          final result = negativeKarma.value;

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

  group(
    'Testing on percentage',
    () {
      test(
        'should return the correct percentage when the value is right',
        () {
          // Act
          final result = validKarma.percentage;

          // Assert
          expect(result, 50.0);
        },
      );

      test(
        'should return 0.0 when the value is left',
        () {
          // Act
          final result = overLimitKarma.percentage;

          // Assert
          expect(result, 0.0);
        },
      );
    },
  );

  group(
    'Testing on leftPercentage',
    () {
      test(
        'should return the correct left percentage when the value is right',
        () {
          // Act
          final result = validKarma.leftPercentage;

          // Assert
          expect(result, 50.0);
        },
      );

      test(
        'should return 100.0 when the value is left',
        () {
          // Act
          final result = overLimitKarma.leftPercentage;

          // Assert
          expect(result, 100.0);
        },
      );
    },
  );
}
