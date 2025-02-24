import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';

part 'coordinates_dto.freezed.dart';
part 'coordinates_dto.g.dart';

/// Coordinates DTO
@freezed
class CoordinatesDto with _$CoordinatesDto {
  const CoordinatesDto._();

  /// Default constructor
  const factory CoordinatesDto({
    required double latitude,
    required double longitude,
  }) = _CoordinatesDto;

  /// Constructor from [Coordinates]
  factory CoordinatesDto.fromDomain(Coordinates coordinates) => CoordinatesDto(
        latitude: coordinates.latitude.getOrCrash(),
        longitude: coordinates.longitude.getOrCrash(),
      );

  /// Factory constructor from JSON [Map]
  factory CoordinatesDto.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesDtoFromJson(json);

  /// Returns a [Coordinates] from this DTO
  Coordinates toDomain() => Coordinates(
        latitude: Latitude(latitude),
        longitude: Longitude(longitude),
      );
}
