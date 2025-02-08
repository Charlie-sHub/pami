import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/error.dart';
import 'package:pami/domain/core/failures/failure.dart';

void main() {
  group(
    'UnexpectedValueError',
    () {
      test(
        'should be a subclass of Error',
        () {
          // Arrange
          const failure = Failure<String>.emptyString(failedValue: '');

          // Act
          final error = UnexpectedValueError(failure);

          // Assert
          expect(error, isA<Error>());
        },
      );

      test(
        'should store the provided Failure',
        () {
          // Arrange
          const failedValue = 'test';
          const failure = Failure<String>.emptyString(failedValue: failedValue);

          // Act
          final error = UnexpectedValueError(failure);

          // Assert
          expect(error.valueFailure, failure);
        },
      );

      test(
        'should have a descriptive toString method',
        () {
          // Arrange
          const failedValue = 'test';
          const failure = Failure<String>.emptyString(failedValue: failedValue);

          // Act
          final error = UnexpectedValueError(failure);

          // Assert
          expect(
            error.toString(),
            contains('Unexpected value from at a unrecoverable point'),
          );
          expect(error.toString(), contains(failure.toString()));
        },
      );
    },
  );

  group(
    'UnAuthenticatedError',
    () {
      test(
        'should be a subclass of Error',
        () {
          // Act
          final error = UnAuthenticatedError();

          // Assert
          expect(error, isA<Error>());
        },
      );

      test(
        'should have a descriptive toString method',
        () {
          // Act
          final error = UnAuthenticatedError();

          // Assert
          expect(
            error.toString(),
            contains(
              "Couldn't get the authenticated User at a point "
              'where only authenticated Users should be',
            ),
          );
        },
      );
    },
  );
}
