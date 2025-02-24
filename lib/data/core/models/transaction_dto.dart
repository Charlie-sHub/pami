import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/data/core/misc/server_date_string_converter.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/misc/enums/transaction_status.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

/// Transaction DTO
@freezed
class TransactionDto with _$TransactionDto {
  const TransactionDto._();

  /// Default constructor
  const factory TransactionDto({
    required String id,
    required String shoutOutCreatorId,
    required String interestedId,
    required TransactionStatus status,
    @ServerDateStringConverter() required DateTime dateCreated,
  }) = _TransactionDto;

  /// Constructor from [Transaction]
  factory TransactionDto.fromDomain(Transaction transaction) => TransactionDto(
        id: transaction.id.getOrCrash(),
        shoutOutCreatorId: transaction.shoutOutCreatorId.getOrCrash(),
        interestedId: transaction.interestedId.getOrCrash(),
        status: transaction.status,
        dateCreated: transaction.dateCreated.getOrCrash(),
      );

  /// Factory constructor from JSON [Map]
  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  /// Returns a [Transaction] from this DTO
  Transaction toDomain() => Transaction(
        id: UniqueId.fromUniqueString(id),
        shoutOutCreatorId: UniqueId.fromUniqueString(shoutOutCreatorId),
        interestedId: UniqueId.fromUniqueString(interestedId),
        status: status,
        dateCreated: PastDate(dateCreated),
      );
}
