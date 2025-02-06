import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a Url with the input value '
        'when the input is a valid URL',
        () {
          // Arrange
          const input = 'https://www.example.com';

          // Act
          final result = Url(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Url with the input value '
        'when the input is a valid URL with path',
        () {
          // Arrange
          const input = 'https://www.example.com/path/to/resource';

          // Act
          final result = Url(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Url with the input value '
        'when the input is a valid URL with query parameters',
        () {
          // Arrange
          const input = 'https://www.example.com/search?q=test&page=1';

          // Act
          final result = Url(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Url with the input value '
        'when the input is a valid URL with fragment',
        () {
          // Arrange
          const input = 'https://www.example.com/page#section1';

          // Act
          final result = Url(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Url with the input value '
        'when the input is a valid URL with port',
        () {
          // Arrange
          const input = 'https://www.example.com:8080';

          // Act
          final result = Url(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a Url with the input value '
        'when the input is a valid URL with subdomains',
        () {
          // Arrange
          const input = 'https://subdomain.example.com';

          // Act
          final result = Url(input);

          // Assert
          expect(result.value, right(input));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.emptyString when the input is an empty string',
        () {
          // Arrange
          const input = '';

          // Act
          final result = Url(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.emptyString(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.invalidUrl when the input is not a valid URL',
        () {
          // Arrange
          const input = 'not a url';

          // Act
          final result = Url(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.invalidUrl(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.multiLineString '
        'when the input contains multiple lines',
        () {
          // Arrange
          const input = 'https://www.example.com\nmore';

          // Act
          final result = Url(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.multiLineString(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
