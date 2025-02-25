import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/transactions/transaction_repository_interface.dart';

/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: TransactionRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentTransactionRepository
    implements TransactionRepositoryInterface {
  /// Default constructor
  DevelopmentTransactionRepository(this._logger);

  final Logger _logger;

  @override
  Future<Either<Failure, Unit>> createTransaction(UniqueId shoutOutId) async {
    _logger.d('Creating transaction for shout out: ${shoutOutId.getOrCrash()}');
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> submitKarmaVote({
    UniqueId? shoutOutId,
    bool? vote,
  }) async {
    _logger.d(
      'Submitting karma vote for shout out: ${shoutOutId?.getOrCrash()} '
      'with vote: $vote',
    );
    return right(unit);
  }

  @override
  Future<Either<Failure, List<Transaction>>> fetchUserTransactions(
    UniqueId userId,
  ) async {
    _logger.d('Fetching user transactions for user: ${userId.getOrCrash()}');
    final transactions = [
      getValidTransaction(),
      getValidTransaction().copyWith(id: UniqueId()),
    ];
    _logger.d(
      'Returning mock transactions: ${transactions.map(
        (transaction) => transaction.id,
      )}',
    );
    return right(transactions);
  }

  @override
  Stream<Either<Failure, Transaction>> watchShoutOutForTransaction(
    UniqueId shoutOutId,
  ) {
    _logger.d('Watching shout out for transaction: ${shoutOutId.getOrCrash()}');
    final transaction = getValidTransaction();
    _logger.d('Returning mock transaction: ${transaction.id}');
    return Stream.value(right(transaction));
  }
}
