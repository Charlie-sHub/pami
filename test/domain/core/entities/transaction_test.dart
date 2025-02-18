import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/transaction_status.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../misc/get_valid_transaction.dart';

void main() {
  late Transaction validTransaction;
  late Transaction invalidDateCreatedTransaction;

  setUp(
    () {
      // Arrange
      validTransaction = getValidTransaction();
      invalidDateCreatedTransaction = validTransaction.copyWith(
        dateCreated: PastDate(
          DateTime.now().add(const Duration(days: 10)),
        ),
      );
    },
  );

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () {
          // Act
          final result = validTransaction.isValid;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () {
          // Act
          final result = validTransaction.failureOption;

          // Assert
          expect(result, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Act
          final result = validTransaction.failureOrUnit;

          // Assert
          expect(result, right(unit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidDateCreatedTransaction',
        () {
          // Act
          final result = invalidDateCreatedTransaction.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedTransaction.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedTransaction.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );
    },
  );

  group(
    'empty',
    () {
      test(
        'should return a Transaction with default values',
        () {
          // Act
          final transaction = Transaction.empty();

          // Assert
          expect(transaction.id, isA<UniqueId>());
          expect(transaction.shoutOutCreatorId, isA<UniqueId>());
          expect(transaction.interestedId, isA<UniqueId>());
          expect(transaction.status, TransactionStatus.pending);
          expect(transaction.qrCode, isA<QrCode>());
          expect(transaction.dateCreated, isA<PastDate>());
        },
      );
    },
  );
}
