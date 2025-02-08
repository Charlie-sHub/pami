import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/validation/objects/category_set.dart';

void main() {
  final validCategorySet = CategorySet(
    const {
      Category.food,
      Category.music,
    },
  );
  final emptyCategorySet = CategorySet(
    const {},
  );
  final fullCategorySet = CategorySet(
    const {
      Category.food,
      Category.music,
      Category.sports,
      Category.travel,
      Category.beauty,
    },
  );
  final invalidCategorySet = CategorySet(
    const {
      Category.food,
      Category.music,
      Category.sports,
      Category.travel,
      Category.beauty,
      Category.misc,
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
          // Assert
          expect(
            invalidCategorySet.value,
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
          // Assert
          expect(validCategorySet.failureOrUnit, right(unit));
        },
      );

      test(
        'should return a failure when the value is left',
        () {
          // Assert
          expect(
            invalidCategorySet.failureOrUnit,
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
          // Assert
          expect(validCategorySet.length, 2);
        },
      );

      test(
        'should return 0 when the value is left',
        () {
          // Assert
          expect(invalidCategorySet.length, 0);
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
          // Assert
          expect(fullCategorySet.isFull, true);
        },
      );

      test(
        'should return false when the length is less than maxLength',
        () {
          // Assert
          expect(validCategorySet.isFull, false);
        },
      );

      test(
        'should return false when the length is greater than maxLength',
        () {
          // Assert
          expect(invalidCategorySet.isFull, false);
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
          // Assert
          expect(emptyCategorySet.isEmpty, true);
        },
      );

      test(
        'should return false when the set is not empty',
        () {
          // Assert
          expect(validCategorySet.isEmpty, false);
        },
      );

      test(
        'should return true when the set is invalid',
        () {
          // Assert
          expect(invalidCategorySet.isEmpty, true);
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
          // Assert
          expect(validCategorySet.isNotEmpty, true);
        },
      );

      test(
        'should return false when the set is empty',
        () {
          // Assert
          expect(emptyCategorySet.isNotEmpty, false);
        },
      );

      test(
        'should return false when the set is invalid',
        () {
          // Assert
          expect(invalidCategorySet.isNotEmpty, false);
        },
      );
    },
  );
}
