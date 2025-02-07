import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

part 'user.freezed.dart';

/// User entity
@freezed
class User with _$User {
  const User._();

  /// Default constructor
  const factory User({
    required UniqueId id,
    required EmailAddress email,
    required Name name,
    required EntityDescription bio,
    required Url avatar,
    required bool isVerified,
    required KarmaPercentage karma,
    required Set<UniqueId> interestedShoutOutIds,
    required PastDate lastLogin,
    required PastDate dateCreated,
  }) = _User;

  /// Empty constructor
  factory User.empty() => User(
        id: UniqueId(),
        email: EmailAddress(''),
        name: Name(''),
        bio: EntityDescription(''),
        avatar: Url(''),
        isVerified: false,
        karma: KarmaPercentage(0),
        interestedShoutOutIds: {},
        lastLogin: PastDate(DateTime.now()),
        dateCreated: PastDate(DateTime.now()),
      );

  /// Gets an [Option] of [Failure]
  Option<Failure<dynamic>> get failureOption => email.failureOrUnit
      .andThen(name.failureOrUnit)
      .andThen(bio.failureOrUnit)
      .andThen(avatar.failureOrUnit)
      .andThen(karma.failureOrUnit)
      .andThen(lastLogin.failureOrUnit)
      .andThen(dateCreated.failureOrUnit)
      .fold(some, (_) => none());

  /// Gets an [Either] of [Failure] or [Unit]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [User] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
