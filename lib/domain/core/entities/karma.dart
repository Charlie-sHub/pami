import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'karma.freezed.dart';

/// Karma entity
@freezed
class Karma with _$Karma {
  const Karma._();

  /// Default constructor
  const factory Karma({
    required UniqueId id,
    required UniqueId giverId,
    required UniqueId transactionId,
    required bool isPositive,
    required PastDate dateCreated,
  }) = _Karma;

  /// Empty constructor
  factory Karma.empty() => Karma(
        id: UniqueId(),
        giverId: UniqueId(),
        transactionId: UniqueId(),
        isPositive: false,
        dateCreated: PastDate(DateTime.now()),
      );

  /// Gets an [Option] of [Failure] of any of its fields
  Option<Failure<dynamic>> get failureOption => dateCreated.failureOrUnit.fold(
        some,
        (_) => none(),
      );

  /// Gets an [Either] of [Failure] or [Unit] based on the [failureOption]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [Karma] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
