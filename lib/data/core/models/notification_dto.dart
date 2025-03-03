import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/data/core/misc/server_date_string_converter.dart';
import 'package:pami/domain/core/entities/notification.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'notification_dto.freezed.dart';
part 'notification_dto.g.dart';

/// Notification DTO
@freezed
abstract class NotificationDto with _$NotificationDto {
  const NotificationDto._();

  /// Default constructor
  const factory NotificationDto({
    required String id,
    required String recipientId,
    required String description,
    required bool seen,
    @ServerDateStringConverter() required DateTime dateCreated,
  }) = _NotificationDto;

  /// Constructor from [Notification]
  factory NotificationDto.fromDomain(Notification notification) =>
      NotificationDto(
        id: notification.id.getOrCrash(),
        recipientId: notification.recipientId.getOrCrash(),
        description: notification.description.getOrCrash(),
        seen: notification.seen,
        dateCreated: notification.dateCreated.getOrCrash(),
      );

  /// Factory constructor from JSON [Map]
  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  /// Returns a [Notification] from this DTO
  Notification toDomain() => Notification(
        id: UniqueId.fromUniqueString(id),
        recipientId: UniqueId.fromUniqueString(recipientId),
        description: EntityDescription(description),
        seen: seen,
        dateCreated: PastDate(dateCreated),
      );
}
