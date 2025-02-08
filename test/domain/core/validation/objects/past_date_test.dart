import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';

void main() {
  group(
    'Testing on success',
    () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final expectedPastDate = DateTime(
        pastDate.year,
        pastDate.month,
        pastDate.day,
      );

      test(
        'should return a PastDate with the input value '
        'when the input is in the past',
        () {
          final result = PastDate(pastDate);
          expect(result.value, right(expectedPastDate));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      final futureDate = DateTime.now().add(const Duration(days: 1));
      final expectedFutureDate = DateTime(
        futureDate.year,
        futureDate.month,
        futureDate.day,
      );

      test(
        'should return a Failure.invalidDate when the input is in the future',
        () {
          final result = PastDate(futureDate);
          expect(
            result.value,
            left(
              Failure<DateTime>.invalidDate(failedValue: expectedFutureDate),
            ),
          );
        },
      );
    },
  );
}
