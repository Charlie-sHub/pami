import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:uuid/uuid.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should create a UniqueId with a valid UUID v1 string',
        () {
          // Arrange
          final uniqueId = UniqueId();

          // Act
          final result = uniqueId.value;

          // Assert
          expect(result, isA<Right<ValueFailure<String>, String>>());
          result.fold(
            (_) => fail('Should not be a failure'),
            (id) => expect(Uuid.isValidUUID(fromString: id), true),
          );
        },
      );

      test(
        'should create a UniqueId from a unique string',
        () {
          // Arrange
          const uniqueString = 'my-unique-string';

          // Act
          final uniqueId = UniqueId.fromUniqueString(uniqueString);
          final result = uniqueId.value;

          // Assert
          expect(result, right<ValueFailure<String>, String>(uniqueString));
        },
      );

      test(
        'should create valid UUID v1 strings that are different each time',
        () {
          // Arrange
          final id1 = UniqueId();
          final id2 = UniqueId();

          // Act
          final result1 = id1.value;
          final result2 = id2.value;

          // Assert
          expect(result1, isA<Right<ValueFailure<String>, String>>());
          expect(result2, isA<Right<ValueFailure<String>, String>>());
          result1.fold(
            (_) => fail('Should not be a failure'),
            (uuid1) => result2.fold(
              (_) => fail('Should not be a failure'),
              (uuid2) => expect(uuid1 != uuid2, true),
            ),
          );
        },
      );
    },
  );
}
