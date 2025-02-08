import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/validators/validate_url.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return the input URL when it is a valid http URL',
        () {
          // Arrange
          const input = 'http://www.example.com';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input URL when it is a valid https URL',
        () {
          // Arrange
          const input = 'https://www.example.com';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input URL when it is a valid URL without protocol',
        () {
          // Arrange
          const input = 'www.example.com';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input URL when it is a valid URL with a path',
        () {
          // Arrange
          const input = 'https://www.example.com/path/to/page';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input URL '
        'when it is a valid URL with a query parameter',
        () {
          // Arrange
          const input = 'https://www.example.com/path?param=value';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input URL when it is a valid URL with subdomains',
        () {
          // Arrange
          const input = 'https://subdomain.example.com';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input URL when it is a valid URL with numbers',
        () {
          // Arrange
          const input = 'https://www.example123.com';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return the input URL '
        'when it is a valid URL with special characters',
        () {
          // Arrange
          const input = 'https://www.exam-ple.com';

          // Act
          final result = validateUrl(input);

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
        'should return a Failure.invalidUrl when the input is an empty string',
        () {
          // Arrange
          const input = '';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidUrl(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidUrl when the input is not a URL',
        () {
          // Arrange
          const input = 'not a url';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidUrl(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidUrl '
        'when the input is missing the domain',
        () {
          // Arrange
          const input = 'https://.com';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidUrl(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidUrl '
        'when the input is missing the top level domain',
        () {
          // Arrange
          const input = 'https://www.example';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidUrl(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidUrl '
        'when the input has an invalid top level domain',
        () {
          // Arrange
          const input = 'https://www.example.c';

          // Act
          final result = validateUrl(input);

          // Assert
          expect(
            result,
            left<Failure<String>, String>(
              const Failure.invalidUrl(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
