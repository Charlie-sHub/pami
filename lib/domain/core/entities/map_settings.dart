import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

part 'map_settings.freezed.dart';

/// MapSettings entity
@freezed
abstract class MapSettings with _$MapSettings {
  const MapSettings._();

  /// Default constructor
  const factory MapSettings({
    required MapRadius radius,
    required ShoutOutType type,
    required Set<Category> categories,
  }) = _MapSettings;

  /// Empty constructor
  factory MapSettings.empty() => MapSettings(
        radius: MapRadius(1),
        type: ShoutOutType.offer,
        categories: {},
      );

  /// Gets an [Option] of [Failure] of any of its fields
  Option<Failure<dynamic>> get failureOption => radius.failureOrUnit.fold(
        some,
        (_) => none(),
      );

  /// Gets an [Either] of [Failure] or [Unit] based on the [failureOption]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [MapSettings] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
