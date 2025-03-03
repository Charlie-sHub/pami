import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';

part 'coordinates.freezed.dart';

/// Coordinates entity
@freezed
abstract class Coordinates with _$Coordinates {
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

  /// Gets an [Option] of [Failure] of any of its fields
  Option<Failure<dynamic>> get failureOption => Either.map2(
        latitude.failureOrUnit,
        longitude.failureOrUnit,
        (_, __) => unit,
      ).fold(
        some,
        (_) => none(),
      );

  /// Gets an [Either] of [Failure] or [Unit] based on the [failureOption]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [Coordinates] is valid
  bool get isValid => failureOption.isNone();
}
