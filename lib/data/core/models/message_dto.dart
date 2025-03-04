import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/data/core/misc/server_date_string_converter.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

/// Message DTO
@freezed
abstract class MessageDto with _$MessageDto {
  const MessageDto._();

  /// Default constructor
  const factory MessageDto({
    required String id,
    required String senderId,
    required String content,
    required bool isRead,
    @ServerDateStringConverter() required DateTime dateCreated,
  }) = _MessageDto;

  /// Constructor from [Message]
  factory MessageDto.fromDomain(Message message) => MessageDto(
        id: message.id.getOrCrash(),
        senderId: message.senderId.getOrCrash(),
        content: message.content.getOrCrash(),
        isRead: message.isRead,
        dateCreated: message.dateCreated.getOrCrash(),
      );

  /// Factory constructor from JSON [Map]
  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  /// Returns a [Message] from this DTO
  Message toDomain() => Message(
        id: UniqueId.fromUniqueString(id),
        senderId: UniqueId.fromUniqueString(senderId),
        content: MessageContent(content),
        isRead: isRead,
        dateCreated: PastDate(dateCreated),
      );
}
