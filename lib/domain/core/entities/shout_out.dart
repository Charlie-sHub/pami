import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

part 'shout_out.freezed.dart';

/// ShoutOut entity
@freezed
class ShoutOut with _$ShoutOut {
  const ShoutOut._();

  /// Default constructor
  const factory ShoutOut({
    required UniqueId id,
    required UniqueId creatorId,
    required ShoutOutType type,
    required Name title,
    required EntityDescription description,
    required Coordinates coordinates,
    required Minutes duration,
    required Set<Category> categories,
    required Set<Url> imageUrls,
    required bool isOpen,
    required PastDate dateCreated,
  }) = _ShoutOut;

  /// Empty constructor
  factory ShoutOut.empty() => ShoutOut(
        id: UniqueId(),
        creatorId: UniqueId(),
        type: ShoutOutType.request,
        title: Name(''),
        description: EntityDescription(''),
        coordinates: Coordinates.empty(),
        duration: Minutes(0),
        categories: {},
        imageUrls: {},
        isOpen: false,
        dateCreated: PastDate(DateTime.now()),
      );

  /// Gets an [Option] of [Failure]
  Option<Failure<dynamic>> get failureOption => title.failureOrUnit
      .andThen(description.failureOrUnit)
      .andThen(coordinates.failureOrUnit)
      .andThen(duration.failureOrUnit)
      .andThen(dateCreated.failureOrUnit)
      .fold(some, (_) => none());

  /// Gets an [Either] of [Failure] or [Unit]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [ShoutOut] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
