import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:uuid/uuid.dart';

void main() {
  test(
    'should create a UniqueId with a valid UUID v1 string',
    () {
      // Act
      final result = UniqueId();

      // Assert
      expect(result.value, isA<Right<Failure<String>, String>>());
      result.value.fold(
        (l) => fail('Should not be a failure'),
        (r) => expect(Uuid.isValidUUID(fromString: r), true),
      );
    },
  );

  test(
    'should create a UniqueId from a unique string',
    () {
      // Arrange
      const uniqueString = 'my-unique-string';

      // Act
      final result = UniqueId.fromUniqueString(uniqueString);

      // Assert
      expect(result.value, right(uniqueString));
    },
  );

  test(
    'should create a UniqueId with a valid UUID v1 string '
    'and be different each time',
    () {
      // Act
      final result1 = UniqueId();
      final result2 = UniqueId();

      // Assert
      expect(result1.value, isA<Right<Failure<String>, String>>());
      expect(result2.value, isA<Right<Failure<String>, String>>());
      result1.value.fold(
        (l) => fail('Should not be a failure'),
        (r1) => result2.value.fold(
          (l) => fail('Should not be a failure'),
          (r2) => expect(r1 != r2, true),
        ),
      );
    },
  );
}
