import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';

import '../../../misc/get_valid_karma.dart';

void main() {
  final validKarma = getValidKarma();
  final invalidDateCreatedKarma = validKarma.copyWith(
    dateCreated: PastDate(
      DateTime.now().add(const Duration(days: 10)),
    ),
  );

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () async {
          // Assert
          expect(validKarma.isValid, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () async {
          // Assert
          expect(validKarma.failureOption, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () async {
          // Assert
          expect(validKarma.failureOrUnit, right(unit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidDateCreatedKarma',
        () async {
          // Assert
          expect(invalidDateCreatedKarma.isValid, false);
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () async {
          // Assert
          expect(
            invalidDateCreatedKarma.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () async {
          // Assert
          expect(
            invalidDateCreatedKarma.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );
    },
  );
}
