import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:qr_flutter/qr_flutter.dart';

part 'transaction.freezed.dart';

/// Transaction entity
@freezed
class Transaction with _$Transaction {
  const Transaction._();

  /// Default constructor
  const factory Transaction({
    required UniqueId id,
    required UniqueId shoutOutCreatorId,
    required UniqueId interestedId,
    required bool isCompleted,
    required QrCode qrCode,
    required PastDate dateCreated,
  }) = _Transaction;

  /// Empty constructor
  factory Transaction.empty() => Transaction(
        id: UniqueId(),
        shoutOutCreatorId: UniqueId(),
        interestedId: UniqueId(),
        isCompleted: false,
        qrCode: QrCode(
          1,
          QrErrorCorrectLevel.L,
        ),
        dateCreated: PastDate(DateTime.now()),
      );

  /// Gets an [Option] of [Failure]
  Option<Failure<dynamic>> get failureOption => dateCreated.failureOrUnit.fold(
        some,
        (_) => none(),
      );

  /// Gets an [Either] of [Failure] or [Unit]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [Transaction] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
