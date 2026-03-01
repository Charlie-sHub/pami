import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a KarmaPercentage with the input value '
        'when the input is valid',
        () {
          // Arrange
          const validKarmaPercentage = 50.0;
          final validKarma = KarmaPercentage(validKarmaPercentage);

          // Act
          final result = validKarma.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(50));
        },
      );

      test(
        'should return a KarmaPercentage with the input value '
        'when the input is at the limit',
        () {
          // Arrange
          const limitKarmaPercentage = KarmaPercentage.limit;
          final limitKarma = KarmaPercentage(limitKarmaPercentage);

          // Act
          final result = limitKarma.value;

          // Assert
          expect(
            result,
            right<ValueFailure<double>, double>(KarmaPercentage.limit),
          );
        },
      );

      test(
        'should return a KarmaPercentage with the input value '
        'when the input is 0',
        () {
          // Arrange
          const zeroKarmaPercentage = 0.0;
          final zeroKarma = KarmaPercentage(zeroKarmaPercentage);

          // Act
          final result = zeroKarma.value;

          // Assert
          expect(result, right<ValueFailure<double>, double>(0));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a ValueFailure.doubleOutOfBounds '
        'when the input exceeds the limit',
        () {
          // Arrange
          const overLimitKarmaPercentage = KarmaPercentage.limit + 0.1;
          final overLimitKarma = KarmaPercentage(overLimitKarmaPercentage);

          // Act
          final result = overLimitKarma.value;

          // Assert
          expect(
            result,
            left<ValueFailure<double>, double>(
              const ValueFailure<double>.doubleOutOfBounds(
                failedValue: KarmaPercentage.limit + 0.1,
              ),
            ),
          );
        },
      );

      test(
        'should return a ValueFailure.doubleOutOfBounds '
        'when the input is negative',
        () {
          // Arrange
          const negativeKarmaPercentage = -1.0;
          final negativeKarma = KarmaPercentage(negativeKarmaPercentage);

          // Act
          final result = negativeKarma.value;

          // Assert
          expect(
            result,
            left<ValueFailure<double>, double>(
              const ValueFailure<double>.doubleOutOfBounds(
                failedValue: -1,
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
          // Arrange
          const validKarmaPercentage = 50.0;
          final validKarma = KarmaPercentage(validKarmaPercentage);

          // Act
          final result = validKarma.percentage;

          // Assert
          expect(result, 50.0);
        },
      );

      test(
        'should return 0.0 when the value is left',
        () {
          // Arrange
          const overLimitKarmaPercentage = KarmaPercentage.limit + 0.1;
          final overLimitKarma = KarmaPercentage(overLimitKarmaPercentage);

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
          // Arrange
          const validKarmaPercentage = 50.0;
          final validKarma = KarmaPercentage(validKarmaPercentage);

          // Act
          final result = validKarma.leftPercentage;

          // Assert
          expect(result, 50.0);
        },
      );

      test(
        'should return 100.0 when the value is left',
        () {
          // Arrange
          const overLimitKarmaPercentage = KarmaPercentage.limit + 0.1;
          final overLimitKarma = KarmaPercentage(overLimitKarmaPercentage);

          // Act
          final result = overLimitKarma.leftPercentage;

          // Assert
          expect(result, 100.0);
        },
      );
    },
  );
}
