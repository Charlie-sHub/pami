import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/validation/objects/category_set.dart';

void main() {
  late CategorySet validCategorySet;
  late CategorySet emptyCategorySet;
  late CategorySet fullCategorySet;
  late CategorySet invalidCategorySet;

  setUp(
    () {
      // Arrange
      validCategorySet = CategorySet(
        const {
          Category.food,
          Category.music,
        },
      );
      emptyCategorySet = CategorySet(
        const {},
      );
      fullCategorySet = CategorySet(
        const {
          Category.food,
          Category.music,
          Category.sports,
          Category.travel,
          Category.beauty,
        },
      );
      invalidCategorySet = CategorySet(
        const {
          Category.food,
          Category.music,
          Category.sports,
          Category.travel,
          Category.beauty,
          Category.misc,
        },
      );
    },
  );

  group(
    'constructor',
    () {
      test(
        'should return a CategorySet with the input value '
        'when the input is valid',
        () {
          // Arrange
          final validSet = validCategorySet.getOrCrash();

          // Assert
          expect(validCategorySet.value, right(validSet));
        },
      );

      test(
        'should return a Failure.collectionExceedsLength '
        'when the input set exceeds the max length',
        () {
          // Act
          final result = invalidCategorySet.value;

          // Assert
          expect(
            result,
            left(
              const Failure<Set<Category>>.collectionExceedsLength(
                failedValue: {
                  Category.food,
                  Category.music,
                  Category.sports,
                  Category.travel,
                  Category.beauty,
                  Category.misc,
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
        'should return unit when the value is right',
        () {
          // Act
          final result = validCategorySet.failureOrUnit;

          // Assert
          expect(result, right(unit));
        },
      );

      test(
        'should return a failure when the value is left',
        () {
          // Act
          final result = invalidCategorySet.failureOrUnit;

          // Assert
          expect(
            result,
            left(
              const Failure<Set<Category>>.collectionExceedsLength(
                failedValue: {
                  Category.food,
                  Category.music,
                  Category.sports,
                  Category.travel,
                  Category.beauty,
                  Category.misc,
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
        'should return the correct length when the value is right',
        () {
          // Act
          final result = validCategorySet.length;

          // Assert
          expect(result, 2);
        },
      );

      test(
        'should return 0 when the value is left',
        () {
          // Act
          final result = invalidCategorySet.length;

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
        'should return true when the length is equal to maxLength',
        () {
          // Act
          final result = fullCategorySet.isFull;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when the length is less than maxLength',
        () {
          // Act
          final result = validCategorySet.isFull;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return false when the length is greater than maxLength',
        () {
          // Act
          final result = invalidCategorySet.isFull;

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
        'should return true when the set is empty',
        () {
          // Act
          final result = emptyCategorySet.isEmpty;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when the set is not empty',
        () {
          // Act
          final result = validCategorySet.isEmpty;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return true when the set is invalid',
        () {
          // Act
          final result = invalidCategorySet.isEmpty;

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
        'should return true when the set is not empty',
        () {
          // Act
          final result = validCategorySet.isNotEmpty;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when the set is empty',
        () {
          // Act
          final result = emptyCategorySet.isNotEmpty;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return false when the set is invalid',
        () {
          // Act
          final result = invalidCategorySet.isNotEmpty;

          // Assert
          expect(result, false);
        },
      );
    },
  );
}
