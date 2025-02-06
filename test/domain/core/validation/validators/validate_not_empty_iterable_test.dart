import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_not_empty_iterable.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input iterable when it contains one element',
        () {
          // Arrange
          const input = [1];

          // Act
          final result = validateNotEmptyIterable(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input iterable when it contains multiple elements',
        () {
          // Arrange
          const input = [1, 2, 3];

          // Act
          final result = validateNotEmptyIterable(input);

          // Assert
          expect(result, right(input));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.emptyList when the input iterable is empty',
        () {
          // Arrange
          const input = <dynamic>[];

          // Act
          final result = validateNotEmptyIterable(input);

          // Assert
          expect(
            result,
            left<Failure<Iterable<dynamic>>, Iterable<dynamic>>(
              const Failure.emptyList(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
