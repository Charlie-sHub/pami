import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/data/core/misc/server_date_string_converter.dart';
import 'package:pami/domain/core/entities/contact_message.dart';
import 'package:pami/domain/core/misc/enums/contact_message_type.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'contact_message_dto.freezed.dart';
part 'contact_message_dto.g.dart';

/// Contact Message DTO
@freezed
class ContactMessageDto with _$ContactMessageDto {
  const ContactMessageDto._();

  /// Default constructor
  const factory ContactMessageDto({
    required String id,
    required String senderId,
    required ContactMessageType type,
    required String content,
    @ServerDateStringConverter() required DateTime dateCreated,
  }) = _ContactMessageDto;

  /// Constructor from [ContactMessage]
  factory ContactMessageDto.fromDomain(ContactMessage contactMessage) =>
      ContactMessageDto(
        id: contactMessage.id.getOrCrash(),
        senderId: contactMessage.senderId.getOrCrash(),
        type: contactMessage.type,
        content: contactMessage.content.getOrCrash(),
        dateCreated: contactMessage.dateCreated.getOrCrash(),
      );

  /// Factory constructor from JSON [Map]
  factory ContactMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ContactMessageDtoFromJson(json);

  /// Returns a [](ContactMessage) from this DTO
  ContactMessage toDomain() => ContactMessage(
        id: UniqueId.fromUniqueString(id),
        senderId: UniqueId.fromUniqueString(senderId),
        type: type,
        content: MessageContent(content),
        dateCreated: PastDate(dateCreated),
      );
}
