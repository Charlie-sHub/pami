import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';

part 'coordinates.freezed.dart';

/// Coordinates entity
@freezed
class Coordinates with _$Coordinates {
  const Coordinates._();

  /// Default constructor
  const factory Coordinates({
    required Latitude latitude,
    required Longitude longitude,
  }) = _Coordinates;

  /// Empty constructor
  factory Coordinates.empty() => Coordinates(
        latitude: Latitude(0),
        longitude: Longitude(0),
      );

  /// Gets an [Either] of [Failure] or [Unit]
  Either<Failure<dynamic>, Unit> get failureOrUnit =>
      latitude.failureOrUnit.andThen(longitude.failureOrUnit).fold(
            left,
            (_) => right(unit),
          );

  /// Checks if the [Coordinates] is valid
  bool get isValid => failureOrUnit.isRight();
}
