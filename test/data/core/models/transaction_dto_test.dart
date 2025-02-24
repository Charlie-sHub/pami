import 'package:flutter_test/flutter_test.dart';
import 'package:pami/data/core/models/transaction_dto.dart';

import '../../../misc/get_valid_transaction.dart';

void main() {
  final transaction = getValidTransaction();
  final transactionDto = TransactionDto.fromDomain(transaction);
  final json = transactionDto.toJson();

  group(
    'Testing on success',
    () {
      test(
        'fromDomain should return a valid DTO from a Transaction entity',
        () {
          // act
          final result = TransactionDto.fromDomain(transaction);
          // assert
          expect(result, equals(transactionDto));
        },
      );

      test(
        'toDomain should return a Transaction entity from a valid DTO',
        () {
          // act
          final result = transactionDto.toDomain();
          // assert
          expect(result, equals(transaction));
        },
      );

      test(
        'fromJson should return a valid DTO from a JSON map',
        () {
          // act
          final result = TransactionDto.fromJson(json);
          // assert
          expect(result, equals(transactionDto));
        },
      );

      test(
        'toJson should return a JSON map containing the proper data',
        () {
          // act
          final result = transactionDto.toJson();
          // assert
          expect(result, equals(json));
        },
      );
    },
  );
}
