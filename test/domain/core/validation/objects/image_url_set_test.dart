import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/image_url_set.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

void main() {
  final validImageUrlSet = ImageUrlSet(
    {
      Url('https://a.com'),
      Url('https://b.com'),
    },
  );
  final emptyImageUrlSet = ImageUrlSet(
    const {},
  );
  final fullImageUrlSet = ImageUrlSet(
    {
      Url('https://a.com'),
      Url('https://b.com'),
      Url('https://c.com'),
      Url('https://d.com'),
      Url('https://e.com'),
    },
  );
  final invalidImageUrlSet = ImageUrlSet(
    {
      Url('https://a.com'),
      Url('https://b.com'),
      Url('https://c.com'),
      Url('https://d.com'),
      Url('https://e.com'),
      Url('https://f.com'),
    },
  );

  group(
    'Testing on constructor',
    () {
      test(
        'should return ImageUrlSet with input when valid',
        () {
          // Arrange
          final validSet = validImageUrlSet.getOrCrash();

          // Assert
          expect(validImageUrlSet.value, right(validSet));
        },
      );

      test(
        'should return Failure when input exceeds max length',
        () {
          // Assert
          expect(
            invalidImageUrlSet.value,
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
    'Testing on failureOrUnit',
    () {
      test(
        'should return unit when value is right',
        () {
          // Assert
          expect(validImageUrlSet.failureOrUnit, right(unit));
        },
      );

      test(
        'should return failure when value is left',
        () {
          // Assert
          expect(
            invalidImageUrlSet.failureOrUnit,
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
    'Testing on length',
    () {
      test(
        'should return correct length when value is right',
        () {
          // Assert
          expect(validImageUrlSet.length, 2);
        },
      );

      test(
        'should return 0 when value is left',
        () {
          // Assert
          expect(invalidImageUrlSet.length, 0);
        },
      );
    },
  );

  group(
    'Testing on isFull',
    () {
      test(
        'should return true when length equals maxLength',
        () {
          // Assert
          expect(fullImageUrlSet.isFull, true);
        },
      );

      test(
        'should return false when length is less than maxLength',
        () {
          // Assert
          expect(validImageUrlSet.isFull, false);
        },
      );

      test(
        'should return false when length is greater than maxLength',
        () {
          // Assert
          expect(invalidImageUrlSet.isFull, false);
        },
      );
    },
  );

  group(
    'Testing on isEmpty',
    () {
      test(
        'should return true when set is empty',
        () {
          // Assert
          expect(emptyImageUrlSet.isEmpty, true);
        },
      );

      test(
        'should return false when set is not empty',
        () {
          // Assert
          expect(validImageUrlSet.isEmpty, false);
        },
      );

      test(
        'should return true when set is invalid',
        () {
          // Assert
          expect(invalidImageUrlSet.isEmpty, true);
        },
      );
    },
  );

  group(
    'Testing on isNotEmpty',
    () {
      test(
        'should return true when set is not empty',
        () {
          // Assert
          expect(validImageUrlSet.isNotEmpty, true);
        },
      );

      test(
        'should return false when set is empty',
        () {
          // Assert
          expect(emptyImageUrlSet.isNotEmpty, false);
        },
      );

      test(
        'should return false when set is invalid',
        () {
          // Assert
          expect(invalidImageUrlSet.isNotEmpty, false);
        },
      );
    },
  );
}
