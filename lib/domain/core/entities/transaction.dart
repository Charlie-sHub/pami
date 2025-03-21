import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/transaction_status.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'transaction.freezed.dart';

/// Transaction entity
@freezed
abstract class Transaction with _$Transaction {
  const Transaction._();

  /// Default constructor
  const factory Transaction({
    required UniqueId id,
    required UniqueId shoutOutCreatorId,
    required UniqueId interestedId,
    required TransactionStatus status,
    required PastDate dateCreated,
  }) = _Transaction;

  /// Empty constructor
  factory Transaction.empty() => Transaction(
        id: UniqueId(),
        shoutOutCreatorId: UniqueId.fromUniqueString(''),
        interestedId: UniqueId.fromUniqueString(''),
        status: TransactionStatus.pending,
        dateCreated: PastDate(DateTime.now()),
      );

  /// Gets an [Option] of [Failure] of any of its fields
  Option<Failure<dynamic>> get failureOption => dateCreated.failureOrUnit.fold(
        some,
        (_) => none(),
      );

  /// Gets an [Either] of [Failure] or [Unit] based on the [failureOption]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [Transaction] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
