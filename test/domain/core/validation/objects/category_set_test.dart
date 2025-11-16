import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/validation/objects/category_set.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a CategorySet with the input value '
            'when the input is valid',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.value;

          // Assert
          expect(result, right(input));
        },
      );

      test(
        'should return unit when the value is right',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.failureOrUnit;

          // Assert
          expect(result, right(unit));
        },
      );

      test(
        'should return the correct length when the value is right',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.length;

          // Assert
          expect(result, 2);
        },
      );

      test(
        'should return true when the length is equal to maxLength',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
            Category.sports,
            Category.travel,
            Category.beauty,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.isFull;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when the length is less than maxLength',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.isFull;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return true when the set is empty',
        () {
          // Arrange
          const input = <Category>{};
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.isEmpty;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when the set is not empty',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.isEmpty;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return true when the set is not empty',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.isNotEmpty;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when the set is empty',
        () {
          // Arrange
          const input = <Category>{};
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.isNotEmpty;

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
        'should return a Failure.collectionExceedsLength '
            'when the input set exceeds the max length',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
            Category.sports,
            Category.travel,
            Category.beauty,
            Category.misc,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.value;

          // Assert
          expect(
            result,
            left<Failure<Set<Category>>, Set<Category>>(
              const Failure.collectionExceedsLength(
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

      test(
        'should return a failure when the value is left',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
            Category.sports,
            Category.travel,
            Category.beauty,
            Category.misc,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.failureOrUnit;

          // Assert
          expect(
            result,
            left<Failure<Set<Category>>, Unit>(
              const Failure.collectionExceedsLength(
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

      test(
        'should return 0 when the value is left',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
            Category.sports,
            Category.travel,
            Category.beauty,
            Category.misc,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.length;

          // Assert
          expect(result, 0);
        },
      );

      test(
        'should return false when the length is greater than maxLength',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
            Category.sports,
            Category.travel,
            Category.beauty,
            Category.misc,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.isFull;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return true when the set is invalid',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
            Category.sports,
            Category.travel,
            Category.beauty,
            Category.misc,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.isEmpty;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when the set is invalid',
        () {
          // Arrange
          const input = {
            Category.food,
            Category.music,
            Category.sports,
            Category.travel,
            Category.beauty,
            Category.misc,
          };
          final categorySet = CategorySet(input);

          // Act
          final result = categorySet.isNotEmpty;

          // Assert
          expect(result, false);
        },
      );
    },
  );
}
