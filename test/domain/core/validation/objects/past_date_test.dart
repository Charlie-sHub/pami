import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a PastDate with the input value '
        'when the input is in the past',
        () {
          // Arrange
          final pastDate = DateTime.now().subtract(const Duration(days: 1));
          final expectedPastDate = DateTime(
            pastDate.year,
            pastDate.month,
            pastDate.day,
          );
          final pastDateObject = PastDate(pastDate);

          // Act
          final result = pastDateObject.value;

          // Assert
          expect(result, right(expectedPastDate));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.invalidDate '
        'when the input is in the future',
        () {
          // Arrange
          final futureDate = DateTime.now().add(const Duration(days: 1));
          final expectedFutureDate = DateTime(
            futureDate.year,
            futureDate.month,
            futureDate.day,
          );
          final futureDateObject = PastDate(futureDate);

          // Act
          final result = futureDateObject.value;

          // Assert
          expect(
            result,
            left(
              Failure<DateTime>.invalidDate(
                failedValue: expectedFutureDate,
              ),
            ),
          );
        },
      );
    },
  );
}
