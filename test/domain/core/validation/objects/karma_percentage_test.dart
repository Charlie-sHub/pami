import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';

void main() {
  const validKarmaPercentage = 50.0;
  const limitKarmaPercentage = KarmaPercentage.limit;
  const zeroKarmaPercentage = 0.0;
  const overLimitKarmaPercentage = KarmaPercentage.limit + 0.1;
  final validKarma = KarmaPercentage(validKarmaPercentage);
  final overLimitKarma = KarmaPercentage(overLimitKarmaPercentage);

  group(
    'Testing on success',
    () {
      final limitKarma = KarmaPercentage(limitKarmaPercentage);
      final zeroKarma = KarmaPercentage(zeroKarmaPercentage);

      test(
        'should return a KarmaPercentage with the input value '
        'when the input is valid',
        () {
          // Assert
          expect(validKarma.value, right(validKarmaPercentage));
        },
      );

      test(
        'should return a KarmaPercentage with the input value '
        'when the input is at the limit',
        () {
          // Assert
          expect(limitKarma.value, right(limitKarmaPercentage));
        },
      );

      test(
        'should return a KarmaPercentage with the input value '
        'when the input is 0',
        () {
          // Assert
          expect(zeroKarma.value, right(zeroKarmaPercentage));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      const negativeKarmaPercentage = -1.0;
      final negativeKarma = KarmaPercentage(negativeKarmaPercentage);

      test(
        'should return a Failure.doubleOutOfBounds '
        'when the input exceeds the limit',
        () {
          // Assert
          expect(
            overLimitKarma.value,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: overLimitKarmaPercentage,
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
            negativeKarma.value,
            left(
              const Failure<double>.doubleOutOfBounds(
                failedValue: negativeKarmaPercentage,
              ),
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
          // Assert
          expect(validKarma.percentage, validKarmaPercentage);
        },
      );

      test(
        'should return 0.0 when the value is left',
        () {
          // Assert
          expect(overLimitKarma.percentage, 0.0);
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
          // Assert
          expect(validKarma.leftPercentage, validKarmaPercentage);
        },
      );

      test(
        'should return 100.0 when the value is left',
        () {
          // Assert
          expect(overLimitKarma.leftPercentage, 100.0);
        },
      );
    },
  );
}
