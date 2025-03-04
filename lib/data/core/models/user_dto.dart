import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/data/core/misc/server_date_string_converter.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// User DTO
@freezed
abstract class UserDto with _$UserDto {
  const UserDto._();

  /// Default constructor
  const factory UserDto({
    required String id,
    required String email,
    required String name,
    required String username,
    required String bio,
    required String avatar,
    required bool isVerified,
    required double karma,
    required Set<String> interestedShoutOutIds,
    @ServerDateStringConverter() required DateTime lastLogin,
    @ServerDateStringConverter() required DateTime dateCreated,
  }) = _UserDto;

  /// Constructor from [User]
  factory UserDto.fromDomain(User user) => UserDto(
        id: user.id.getOrCrash(),
        email: user.email.getOrCrash(),
        name: user.name.getOrCrash(),
        username: user.username.getOrCrash(),
        bio: user.bio.getOrCrash(),
        avatar: user.avatar.getOrCrash(),
        isVerified: user.isVerified,
        karma: user.karma.getOrCrash(),
        interestedShoutOutIds: user.interestedShoutOutIds
            .map((uniqueId) => uniqueId.getOrCrash())
            .toSet(),
        lastLogin: user.lastLogin.getOrCrash(),
        dateCreated: user.dateCreated.getOrCrash(),
      );

  /// Factory constructor from JSON [Map]
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  /// Returns a [User] from this DTO
  User toDomain() => User(
        id: UniqueId.fromUniqueString(id),
        email: EmailAddress(email),
        name: Name(name),
        username: Name(username),
        bio: EntityDescription(bio),
        avatar: Url(avatar),
        isVerified: isVerified,
        karma: KarmaPercentage(karma),
        interestedShoutOutIds:
            interestedShoutOutIds.map(UniqueId.fromUniqueString).toSet(),
        lastLogin: PastDate(lastLogin),
        dateCreated: PastDate(dateCreated),
      );
}
