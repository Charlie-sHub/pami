import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_single_line_string.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input string when it is a single line',
        () {
          // Arrange
          const input = 'This is a single line string';

          // Act
          final result = validateSingleLineString(input);

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
        'should return a Failure.multiLineString '
        'when the input string contains a new line',
        () {
          // Arrange
          const input = 'This is a string\nwith a new line';

          // Act
          final result = validateSingleLineString(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.multiLineString(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.multiLineString '
        'when the input string contains multiple new lines',
        () {
          // Arrange
          const input = 'This is a string\nwith multiple\nnew lines';

          // Act
          final result = validateSingleLineString(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.multiLineString(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
