import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:qr_flutter/qr_flutter.dart';

part 'shout_out.freezed.dart';

/// ShoutOut entity
@freezed
abstract class ShoutOut with _$ShoutOut {
  const ShoutOut._();

  /// Default constructor
  const factory ShoutOut({
    required UniqueId id,
    required UniqueId creatorId,
    required Option<User> creatorUser,
    required ShoutOutType type,
    required Name title,
    required EntityDescription description,
    required Coordinates coordinates,
    required Minutes duration,
    required Set<Category> categories,
    required Set<Url> imageUrls,
    required bool isOpen,
    required PastDate dateCreated,
    required QrCode qrCode,
  }) = _ShoutOut;

  /// Empty constructor
  factory ShoutOut.empty() {
    final id = UniqueId();
    return ShoutOut(
      id: id,
      creatorId: UniqueId.fromUniqueString(''),
      creatorUser: none(),
      type: ShoutOutType.request,
      title: Name(''),
      description: EntityDescription(''),
      coordinates: Coordinates.empty(),
      duration: Minutes(0),
      categories: {},
      imageUrls: {},
      isOpen: false,
      dateCreated: PastDate(DateTime.now()),
      qrCode: QrCode.fromData(
        data: id.getOrCrash(),
        errorCorrectLevel: QrErrorCorrectLevel.M,
      ),
    );
  }

  /// Gets an [Option] of [Failure] of any of its fields
  Option<Failure<dynamic>> get failureOption {
    Either<Failure<dynamic>, Unit> asDyn<L>(Either<Failure<L>, Unit> either) =>
        either.leftMap(
          (l) => l as Failure<dynamic>,
        );

    final either = asDyn(title.failureOrUnit)
        .andThen(asDyn(description.failureOrUnit))
        .andThen(asDyn(coordinates.failureOrUnit))
        .andThen(asDyn(duration.failureOrUnit))
        .andThen(asDyn(dateCreated.failureOrUnit))
        .andThen(
          creatorUser.fold(
            () => right<Failure<dynamic>, Unit>(unit),
            (user) => asDyn(user.failureOrUnit),
          ),
        );

    return either.fold(some, (_) => none());
  }

  /// Gets an [Either] of [Failure] or [Unit] based on the [failureOption]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
    () => right(unit),
    left,
  );

  /// Checks if the [ShoutOut] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
