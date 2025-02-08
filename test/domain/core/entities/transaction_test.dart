import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';

import '../../../misc/get_valid_transaction.dart';

void main() {
  final validTransaction = getValidTransaction();
  final invalidDateCreatedTransaction = validTransaction.copyWith(
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
          expect(validTransaction.isValid, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () async {
          // Assert
          expect(validTransaction.failureOption, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () async {
          // Assert
          expect(validTransaction.failureOrUnit, right(unit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidDateCreatedTransaction',
        () async {
          // Assert
          expect(invalidDateCreatedTransaction.isValid, false);
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () async {
          // Assert
          expect(
            invalidDateCreatedTransaction.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () async {
          // Assert
          expect(
            invalidDateCreatedTransaction.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );
    },
  );
}
