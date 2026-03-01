import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/image_url_set.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return ImageUrlSet with input when valid',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.value;

          // Assert
          expect(result, right<ValueFailure<Set<Url>>, Set<Url>>(input));
        },
      );

      test(
        'should return unit when value is right',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.failureOrUnit;

          // Assert
          expect(result, right<ValueFailure<dynamic>, Unit>(unit));
        },
      );

      test(
        'should return correct length when value is right',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.length;

          // Assert
          expect(result, 2);
        },
      );

      test(
        'should return true when length equals maxLength',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
            Url('https://c.com'),
            Url('https://d.com'),
            Url('https://e.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.isFull;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when length is less than maxLength',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.isFull;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return true when set is empty',
        () {
          // Arrange
          final input = <Url>{};
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.isEmpty;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when set is not empty',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.isEmpty;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return true when set is not empty',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.isNotEmpty;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when set is empty',
        () {
          // Arrange
          final input = <Url>{};
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.isNotEmpty;

          // Assert
          expect(result, false);
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return Failure when input exceeds max length',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
            Url('https://c.com'),
            Url('https://d.com'),
            Url('https://e.com'),
            Url('https://f.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.value;

          // Assert
          expect(
            result,
            left<ValueFailure<Set<Url>>, Set<Url>>(
              ValueFailure.collectionExceedsLength(
                failedValue: {
                  Url('https://a.com'),
                  Url('https://b.com'),
                  Url('https://c.com'),
                  Url('https://d.com'),
                  Url('https://e.com'),
                  Url('https://f.com'),
                },
                maxLength: 5,
              ),
            ),
          );
        },
      );

      test(
        'should return failure when value is left',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
            Url('https://c.com'),
            Url('https://d.com'),
            Url('https://e.com'),
            Url('https://f.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.failureOrUnit;

          // Assert
          expect(
            result,
            left<ValueFailure<Set<Url>>, Unit>(
              ValueFailure.collectionExceedsLength(
                failedValue: {
                  Url('https://a.com'),
                  Url('https://b.com'),
                  Url('https://c.com'),
                  Url('https://d.com'),
                  Url('https://e.com'),
                  Url('https://f.com'),
                },
                maxLength: 5,
              ),
            ),
          );
        },
      );

      test(
        'should return 0 when value is left',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
            Url('https://c.com'),
            Url('https://d.com'),
            Url('https://e.com'),
            Url('https://f.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.length;

          // Assert
          expect(result, 0);
        },
      );

      test(
        'should return false when length is greater than maxLength',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
            Url('https://c.com'),
            Url('https://d.com'),
            Url('https://e.com'),
            Url('https://f.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.isFull;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return true when set is invalid',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
            Url('https://c.com'),
            Url('https://d.com'),
            Url('https://e.com'),
            Url('https://f.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.isEmpty;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when set is invalid',
        () {
          // Arrange
          final input = {
            Url('https://a.com'),
            Url('https://b.com'),
            Url('https://c.com'),
            Url('https://d.com'),
            Url('https://e.com'),
            Url('https://f.com'),
          };
          final imageUrlSet = ImageUrlSet(input);

          // Act
          final result = imageUrlSet.isNotEmpty;

          // Assert
          expect(result, false);
        },
      );
    },
  );
}
