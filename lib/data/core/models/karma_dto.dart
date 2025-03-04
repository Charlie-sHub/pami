import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/data/core/misc/server_date_string_converter.dart';
import 'package:pami/domain/core/entities/karma.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'karma_dto.freezed.dart';
part 'karma_dto.g.dart';

/// Karma DTO
@freezed
abstract class KarmaDto with _$KarmaDto {
  const KarmaDto._();

  /// Default constructor
  const factory KarmaDto({
    required String id,
    required String giverId,
    required String transactionId,
    required bool isPositive,
    @ServerDateStringConverter() required DateTime dateCreated,
  }) = _KarmaDto;

  /// Constructor from [Karma]
  factory KarmaDto.fromDomain(Karma karma) => KarmaDto(
        id: karma.id.getOrCrash(),
        giverId: karma.giverId.getOrCrash(),
        transactionId: karma.transactionId.getOrCrash(),
        isPositive: karma.isPositive,
        dateCreated: karma.dateCreated.getOrCrash(),
      );

  /// Factory constructor from JSON [Map]
  factory KarmaDto.fromJson(Map<String, dynamic> json) =>
      _$KarmaDtoFromJson(json);

  /// Returns a [Karma] from this DTO
  Karma toDomain() => Karma(
        id: UniqueId.fromUniqueString(id),
        giverId: UniqueId.fromUniqueString(giverId),
        transactionId: UniqueId.fromUniqueString(transactionId),
        isPositive: isPositive,
        dateCreated: PastDate(dateCreated),
      );
}
