import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/image_url_set.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

void main() {
  late ImageUrlSet validImageUrlSet;
  late ImageUrlSet emptyImageUrlSet;
  late ImageUrlSet fullImageUrlSet;
  late ImageUrlSet invalidImageUrlSet;

  setUp(
    () {
      // Arrange
      validImageUrlSet = ImageUrlSet(
        {
          Url('https://a.com'),
          Url('https://b.com'),
        },
      );
      emptyImageUrlSet = ImageUrlSet(
        const {},
      );
      fullImageUrlSet = ImageUrlSet(
        {
          Url('https://a.com'),
          Url('https://b.com'),
          Url('https://c.com'),
          Url('https://d.com'),
          Url('https://e.com'),
        },
      );
      invalidImageUrlSet = ImageUrlSet(
        {
          Url('https://a.com'),
          Url('https://b.com'),
          Url('https://c.com'),
          Url('https://d.com'),
          Url('https://e.com'),
          Url('https://f.com'),
        },
      );
    },
  );

  group(
    'constructor',
    () {
      test(
        'should return ImageUrlSet with input when valid',
        () {
          // Arrange
          final validSet = validImageUrlSet.getOrCrash();

          // Act
          final result = validImageUrlSet.value;

          // Assert
          expect(result, right(validSet));
        },
      );

      test(
        'should return Failure when input exceeds max length',
        () {
          // Act
          final result = invalidImageUrlSet.value;

          // Assert
          expect(
            result,
            left(
              Failure<Set<Url>>.collectionExceedsLength(
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
    },
  );

  group(
    'failureOrUnit',
    () {
      test(
        'should return unit when value is right',
        () {
          // Act
          final result = validImageUrlSet.failureOrUnit;

          // Assert
          expect(result, right(unit));
        },
      );

      test(
        'should return failure when value is left',
        () {
          // Act
          final result = invalidImageUrlSet.failureOrUnit;

          // Assert
          expect(
            result,
            left(
              Failure<Set<Url>>.collectionExceedsLength(
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
    },
  );

  group(
    'length',
    () {
      test(
        'should return correct length when value is right',
        () {
          // Act
          final result = validImageUrlSet.length;

          // Assert
          expect(result, 2);
        },
      );

      test(
        'should return 0 when value is left',
        () {
          // Act
          final result = invalidImageUrlSet.length;

          // Assert
          expect(result, 0);
        },
      );
    },
  );

  group(
    'isFull',
    () {
      test(
        'should return true when length equals maxLength',
        () {
          // Act
          final result = fullImageUrlSet.isFull;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when length is less than maxLength',
        () {
          // Act
          final result = validImageUrlSet.isFull;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return false when length is greater than maxLength',
        () {
          // Act
          final result = invalidImageUrlSet.isFull;

          // Assert
          expect(result, false);
        },
      );
    },
  );

  group(
    'isEmpty',
    () {
      test(
        'should return true when set is empty',
        () {
          // Act
          final result = emptyImageUrlSet.isEmpty;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when set is not empty',
        () {
          // Act
          final result = validImageUrlSet.isEmpty;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return true when set is invalid',
        () {
          // Act
          final result = invalidImageUrlSet.isEmpty;

          // Assert
          expect(result, true);
        },
      );
    },
  );

  group(
    'isNotEmpty',
    () {
      test(
        'should return true when set is not empty',
        () {
          // Act
          final result = validImageUrlSet.isNotEmpty;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when set is empty',
        () {
          // Act
          final result = emptyImageUrlSet.isNotEmpty;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return false when set is invalid',
        () {
          // Act
          final result = invalidImageUrlSet.isNotEmpty;

          // Assert
          expect(result, false);
        },
      );
    },
  );
}
