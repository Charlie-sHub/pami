import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:uuid/uuid.dart';

void main() {
  test(
    'should create a UniqueId with a valid UUID v1 string',
    () {
      final result = UniqueId();
      expect(result.value, isA<Right<Failure<String>, String>>());
      result.value.fold(
        (_) => fail('Should not be a failure'),
        (id) => expect(Uuid.isValidUUID(fromString: id), true),
      );
    },
  );

  test(
    'should create a UniqueId from a unique string',
    () {
      const uniqueString = 'my-unique-string';
      final result = UniqueId.fromUniqueString(uniqueString);
      expect(result.value, right(uniqueString));
    },
  );

  test(
    'should create a UniqueId with a valid UUID v1 string '
    'and be different each time',
    () {
      final result1 = UniqueId();
      final result2 = UniqueId();
      expect(result1.value, isA<Right<Failure<String>, String>>());
      expect(result2.value, isA<Right<Failure<String>, String>>());
      result1.value.fold(
        (_) => fail('Should not be a failure'),
        (id1) => result2.value.fold(
          (_) => fail('Should not be a failure'),
          (id2) => expect(id1 != id2, true),
        ),
      );
    },
  );
}
