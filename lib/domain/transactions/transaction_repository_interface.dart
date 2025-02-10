import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Interface for the transaction repository
abstract class TransactionRepositoryInterface {
  /// Creates a new transaction when offer is created
  Future<Either<Failure, Transaction>> createTransaction(String offerId);

  /// Confirms transaction when QR is scanned
  Future<Either<Failure, Unit>> confirmTransaction({
    String transactionId,
    String receiverId,
  });

  /// Submits karma vote
  Future<Either<Failure, Unit>> submitKarmaVote({
    String transactionId,
    bool vote,
  });

  /// Fetch user's transactions
  Future<Either<Failure, List<Transaction>>> fetchUserTransactions(
    String userId,
  );

  /// Watches specific transaction for updates
  Stream<Either<Failure, Transaction>> watchTransaction(String transactionId);

  /// Cancels transaction
  Future<Either<Failure, Unit>> cancelTransaction(String transactionId);
}
