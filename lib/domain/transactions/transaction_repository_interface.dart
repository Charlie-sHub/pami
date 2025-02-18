import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the transaction repository
abstract class TransactionRepositoryInterface {
  /// Creates a new transaction¡
  Future<Either<Failure, Unit>> createTransaction(
    UniqueId shoutOutId,
  );

  /// Submits karma vote
  Future<Either<Failure, Unit>> submitKarmaVote({
    UniqueId shoutOutId,
    bool vote,
  });

  /// Fetch user's transactions
  Future<Either<Failure, List<Transaction>>> fetchUserTransactions(
    UniqueId userId,
  );

  /// Watches shout out for transaction
  Stream<Either<Failure, Transaction>> watchShoutOutForTransaction(
    UniqueId shoutOutId,
  );
}
