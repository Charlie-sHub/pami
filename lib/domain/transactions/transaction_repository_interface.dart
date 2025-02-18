import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the transaction repository
abstract class TransactionRepositoryInterface {
  /// Creates a new transaction when offer is created
  Future<Either<Failure, Transaction>> createTransaction(
    String offerId,
  );

  /// Confirms transaction when QR is scanned
  Future<Either<Failure, Unit>> confirmTransaction({
    UniqueId transactionId,
    UniqueId receiverId,
  });

  /// Submits karma vote
  Future<Either<Failure, Unit>> submitKarmaVote({
    UniqueId transactionId,
    bool vote,
  });

  /// Fetch user's transactions
  Future<Either<Failure, List<Transaction>>> fetchUserTransactions(
    UniqueId userId,
  );

  /// Watches specific transaction for updates
  Stream<Either<Failure, Transaction>> watchTransaction(
    UniqueId transactionId,
  );

  /// Cancels transaction
  Future<Either<Failure, Unit>> cancelTransaction(
    UniqueId transactionId,
  );
}
