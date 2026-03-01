import 'package:dartz/dartz.dart' show optionOf;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/data/core/misc/server_date_string_converter.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/misc/enums/transaction_status.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'transaction_dto.freezed.dart';

part 'transaction_dto.g.dart';

/// Transaction DTO
@freezed
abstract class TransactionDto with _$TransactionDto {
  /// Default constructor
  const factory TransactionDto({
    required String id,
    required String shoutOutId,
    required String shoutOutCreatorId,
    required String interestedId,
    required Map<String, String> participants,
    required TransactionStatus status,
    required String shoutOutTitle,
    required ShoutOutType shoutOutType,
    required bool? isPositiveForCreator,
    @ServerDateStringConverter() required DateTime dateCreated,
  }) = _TransactionDto;
  const TransactionDto._();

  /// Constructor from [Transaction]
  factory TransactionDto.fromDomain(Transaction transaction) => TransactionDto(
    id: transaction.id.getOrCrash(),
    shoutOutId: transaction.shoutOutId.getOrCrash(),
    shoutOutCreatorId: transaction.shoutOutCreatorId.getOrCrash(),
    interestedId: transaction.interestedId.getOrCrash(),
    participants: {
      'creatorId': transaction.participants['creatorId']!.getOrCrash(),
      'interestedId': transaction.participants['interestedId']!.getOrCrash(),
    },
    shoutOutTitle: transaction.shoutOutTitle.getOrCrash(),
    shoutOutType: transaction.shoutOutType,
    isPositiveForCreator: transaction.isPositiveForCreator.fold(
      () => null,
      (value) => value,
    ),
    status: transaction.status,
    dateCreated: transaction.dateCreated.getOrCrash(),
  );

  /// Factory constructor from JSON [Map]
  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  /// Returns a [Transaction] from this DTO
  Transaction toDomain() {
    final creatorId = UniqueId.fromUniqueString(shoutOutCreatorId);
    final interestedUserId = UniqueId.fromUniqueString(interestedId);

    return Transaction(
      id: UniqueId.fromUniqueString(id),
      shoutOutId: UniqueId.fromUniqueString(shoutOutId),
      shoutOutCreatorId: creatorId,
      interestedId: interestedUserId,
      participants: {
        'creatorId': creatorId,
        'interestedId': interestedUserId,
      },
      status: status,
      shoutOutType: shoutOutType,
      shoutOutTitle: Name(shoutOutTitle),
      isPositiveForCreator: optionOf(isPositiveForCreator),
      dateCreated: PastDate(dateCreated),
    );
  }
}
