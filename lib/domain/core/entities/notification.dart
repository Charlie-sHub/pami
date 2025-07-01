import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'notification.freezed.dart';

/// Notification entity
@freezed
abstract class Notification with _$Notification {
  const Notification._();

  /// Default constructor
  const factory Notification({
    required UniqueId id,
    required UniqueId recipientId,
    required EntityDescription description,
    required bool seen,
    required PastDate dateCreated,
  }) = _Notification;

  /// Empty constructor
  factory Notification.empty() => Notification(
        id: UniqueId(),
        recipientId: UniqueId.fromUniqueString(''),
        description: EntityDescription(''),
        seen: false,
        dateCreated: PastDate(DateTime.now()),
      );

  /// Gets an [Option] of [Failure] of any of its fields
  Option<Failure<dynamic>> get failureOption => Either.map2(
        description.failureOrUnit,
        dateCreated.failureOrUnit,
        (_, _) => unit,
      ).fold(
        some,
        (_) => none(),
      );

  /// Gets an [Either] of [Failure] or [Unit] based on the [failureOption]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [Notification] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
