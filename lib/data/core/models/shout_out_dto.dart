import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/data/core/misc/server_date_string_converter.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:qr_flutter/qr_flutter.dart';

part 'shout_out_dto.freezed.dart';
part 'shout_out_dto.g.dart';

/// ShoutOut DTO
@freezed
class ShoutOutDto with _$ShoutOutDto {
  const ShoutOutDto._();

  /// Default constructor
  const factory ShoutOutDto({
    required String id,
    required String creatorId,
    required ShoutOutType type,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required double duration,
    required Set<Category> categories,
    required Set<String> imageUrls,
    required bool isOpen,
    @ServerDateStringConverter() required DateTime dateCreated,
  }) = _ShoutOutDto;

  /// Constructor from [ShoutOut]
  factory ShoutOutDto.fromDomain(ShoutOut shoutOut) => ShoutOutDto(
        id: shoutOut.id.getOrCrash(),
        creatorId: shoutOut.creatorId.getOrCrash(),
        type: shoutOut.type,
        title: shoutOut.title.getOrCrash(),
        description: shoutOut.description.getOrCrash(),
        latitude: shoutOut.coordinates.latitude.getOrCrash(),
        longitude: shoutOut.coordinates.longitude.getOrCrash(),
        duration: shoutOut.duration.getOrCrash(),
        categories: shoutOut.categories,
        imageUrls: shoutOut.imageUrls.map((url) => url.getOrCrash()).toSet(),
        isOpen: shoutOut.isOpen,
        dateCreated: shoutOut.dateCreated.getOrCrash(),
      );

  /// Factory constructor from JSON [Map]
  factory ShoutOutDto.fromJson(Map<String, dynamic> json) =>
      _$ShoutOutDtoFromJson(json);

  /// Returns a [ShoutOut] from this DTO
  ShoutOut toDomain() => ShoutOut(
        id: UniqueId.fromUniqueString(id),
        creatorId: UniqueId.fromUniqueString(creatorId),
        type: type,
        title: Name(title),
        description: EntityDescription(description),
        coordinates: Coordinates(
          latitude: Latitude(latitude),
          longitude: Longitude(longitude),
        ),
        duration: Minutes(duration),
        categories: categories,
        imageUrls: imageUrls.map(Url.new).toSet(),
        isOpen: isOpen,
        dateCreated: PastDate(dateCreated),
        qrCode: QrCode.fromData(
          data: id,
          errorCorrectLevel: QrErrorCorrectLevel.M,
        ),
      );
}
