import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/data/core/misc/server_date_string_converter.dart';
import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

/// Conversation DTO
@freezed
abstract class ConversationDto with _$ConversationDto {
  const ConversationDto._();

  /// Default constructor
  const factory ConversationDto({
    required String id,
    required String shoutOutCreatorId,
    required String interestedId,
    required String lastMessage,
    @ServerDateStringConverter() required DateTime lastMessageDate,
    @ServerDateStringConverter() required DateTime dateCreated,
  }) = _ConversationDto;

  /// Constructor from [Conversation]
  factory ConversationDto.fromDomain(Conversation conversation) =>
      ConversationDto(
        id: conversation.id.getOrCrash(),
        shoutOutCreatorId: conversation.shoutOutCreatorId.getOrCrash(),
        interestedId: conversation.interestedId.getOrCrash(),
        lastMessage: conversation.lastMessage.getOrCrash(),
        lastMessageDate: conversation.lastMessageDate,
        dateCreated: conversation.dateCreated.getOrCrash(),
      );

  /// Factory constructor from JSON [Map]
  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);

  /// Returns a [Conversation] from this DTO
  Conversation toDomain() => Conversation(
        id: UniqueId.fromUniqueString(id),
        shoutOutCreatorId: UniqueId.fromUniqueString(shoutOutCreatorId),
        interestedId: UniqueId.fromUniqueString(interestedId),
        lastMessage: MessageContent(lastMessage),
        lastMessageDate: lastMessageDate,
        dateCreated: PastDate(dateCreated),
      );
}
