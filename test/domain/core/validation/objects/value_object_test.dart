import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/error.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/name.dart';

void main() {
  group(
    'failureOrUnit',
    () {
      test(
        'should return right(unit) when value is Right',
        () {
          // Arrange
          const validName = 'John Doe';
          final name = Name(validName);

          // Act
          final result = name.failureOrUnit;

          // Assert
          expect(result, right(unit));
        },
      );

      test(
        'should return left(Failure) when value is Left',
        () {
          // Arrange
          const invalidName = '';
          final name = Name(invalidName);
          const expectedFailure = Failure<String>.emptyString(
            failedValue: invalidName,
          );

          // Act
          final result = name.failureOrUnit;

          // Assert
          expect(result, left(expectedFailure));
        },
      );
    },
  );

  group(
    'isValid',
    () {
      test(
        'should return true when value is Right',
        () {
          // Arrange
          const validName = 'John Doe';
          final name = Name(validName);

          // Act
          final result = name.isValid();

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when value is Left',
        () {
          // Arrange
          const invalidName = '';
          final name = Name(invalidName);

          // Act
          final result = name.isValid();

          // Assert
          expect(result, false);
        },
      );
    },
  );

  group(
    'toString',
    () {
      test(
        'should return the value when value is Right',
        () {
          // Arrange
          const validName = 'John Doe';
          final name = Name(validName);

          // Act
          final result = name.toString();

          // Assert
          expect(result, validName);
        },
      );

      test(
        'should return the failure when value is Left',
        () {
          // Arrange
          const invalidName = '';
          final name = Name(invalidName);
          const expectedFailure = Failure<String>.emptyString(
            failedValue: invalidName,
          );

          // Act
          final result = name.toString();

          // Assert
          expect(result, expectedFailure.toString());
        },
      );
    },
  );

  group(
    'getOrCrash',
    () {
      test(
        'should return the value when value is Right',
        () {
          // Arrange
          const validName = 'John Doe';
          final name = Name(validName);

          // Act
          final result = name.getOrCrash();

          // Assert
          expect(result, validName);
        },
      );

      test(
        'should throw UnexpectedValueError when value is Left',
        () {
          // Arrange
          const invalidName = '';
          final name = Name(invalidName);
          const expectedFailure = Failure<String>.emptyString(
            failedValue: invalidName,
          );

          // Act
          final call = name.getOrCrash;

          // Assert
          expect(call, throwsA(isA<UnexpectedValueError>()));
          expect(
            call,
            throwsA(
              predicate(
                (e) =>
                    e is UnexpectedValueError &&
                    e.valueFailure == expectedFailure,
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'failureOrCrash',
    () {
      test(
        'should return the failure when value is Left',
        () {
          // Arrange
          const invalidName = '';
          final name = Name(invalidName);
          const expectedFailure = Failure<String>.emptyString(
            failedValue: invalidName,
          );

          // Act
          final result = name.failureOrCrash();

          // Assert
          expect(result, expectedFailure);
        },
      );

      test(
        'should throw Error when value is Right',
        () {
          // Arrange
          const validName = 'John Doe';
          final name = Name(validName);

          // Act
          final call = name.failureOrCrash;

          // Assert
          expect(call, throwsA(isA<Error>()));
        },
      );
    },
  );
}
