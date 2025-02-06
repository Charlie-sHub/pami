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
          final input = DateTime.now().subtract(const Duration(days: 1));
          final expectedDate = DateTime(input.year, input.month, input.day);

          // Act
          final result = PastDate(input);

          // Assert
          expect(result.value, right(expectedDate));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.invalidDate when the input is in the future',
        () {
          // Arrange
          final input = DateTime.now().add(const Duration(days: 1));
          final failedValue = DateTime(input.year, input.month, input.day);

          // Act
          final result = PastDate(input);

          // Assert
          expect(
            result.value,
            left(
              Failure<DateTime>.invalidDate(failedValue: failedValue),
            ),
          );
        },
      );
    },
  );
}
