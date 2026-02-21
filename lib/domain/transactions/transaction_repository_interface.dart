import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/failures/app_failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the transaction repository
abstract class TransactionRepositoryInterface {
  /// Creates a new transaction¡
  Future<Either<AppFailure, Unit>> createTransaction(
    UniqueId shoutOutId,
  );

  /// Submits karma vote
  Future<Either<AppFailure, Unit>> submitKarmaVote({
    UniqueId shoutOutId,
    bool vote,
  });

  /// Fetch user's transactions
  Future<Either<AppFailure, List<Transaction>>> fetchUserTransactions(
    UniqueId userId,
  );

  /// Watches shout out for transaction
  Stream<Either<AppFailure, Transaction>> watchShoutOutForTransaction(
    UniqueId shoutOutId,
  );
}
