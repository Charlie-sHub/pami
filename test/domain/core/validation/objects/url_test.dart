import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

void main() {
  group(
    'Testing on success',
    () {
      const validUrl = 'https://www.example.com';
      const validUrlWithPath = 'https://www.example.com/path/to/resource';
      const validUrlWithQueryParams =
          'https://www.example.com/search?q=test&page=1';
      const validUrlWithFragment = 'https://www.example.com/page#section1';
      const validUrlWithPort = 'https://www.example.com:8080';
      const validUrlWithSubdomain = 'https://subdomain.example.com';

      test(
        'should return a Url with the input value '
        'when the input is a valid URL',
        () {
          // Arrange
          final result = Url(validUrl);

          // Assert
          expect(result.value, right(validUrl));
        },
      );

      test(
        'should return a Url with the input value '
        'when the input is a valid URL with path',
        () {
          // Arrange
          final result = Url(validUrlWithPath);

          // Assert
          expect(result.value, right(validUrlWithPath));
        },
      );

      test(
        'should return a Url with the input value '
        'when the input is a valid URL with query parameters',
        () {
          // Arrange
          final result = Url(validUrlWithQueryParams);

          // Assert
          expect(result.value, right(validUrlWithQueryParams));
        },
      );

      test(
        'should return a Url with the input value '
        'when the input is a valid URL with fragment',
        () {
          // Arrange
          final result = Url(validUrlWithFragment);

          // Assert
          expect(result.value, right(validUrlWithFragment));
        },
      );

      test(
        'should return a Url with the input value '
        'when the input is a valid URL with port',
        () {
          // Arrange
          final result = Url(validUrlWithPort);

          // Assert
          expect(result.value, right(validUrlWithPort));
        },
      );

      test(
        'should return a Url with the input value '
        'when the input is a valid URL with subdomains',
        () {
          // Arrange
          final result = Url(validUrlWithSubdomain);

          // Assert
          expect(result.value, right(validUrlWithSubdomain));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      const emptyUrl = '';
      const invalidUrl = 'not a url';
      const multiLineUrl = 'https://www.example.com\nmore';

      test(
        'should return a Failure.emptyString when the input is an empty string',
        () {
          // Arrange
          final result = Url(emptyUrl);

          // Assert
          expect(
            result.value,
            left(const Failure<String>.emptyString(failedValue: emptyUrl)),
          );
        },
      );

      test(
        'should return a Failure.invalidUrl when the input is not a valid URL',
        () {
          // Arrange
          final result = Url(invalidUrl);

          // Assert
          expect(
            result.value,
            left(const Failure<String>.invalidUrl(failedValue: invalidUrl)),
          );
        },
      );

      test(
        'should return a Failure.multiLineString '
        'when the input contains multiple lines',
        () {
          // Arrange
          final result = Url(multiLineUrl);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.multiLineString(
                failedValue: multiLineUrl,
              ),
            ),
          );
        },
      );
    },
  );
}
