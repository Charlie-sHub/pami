import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

Conversation getValidConversation() => Conversation(
      id: UniqueId(),
      shoutOutCreatorId: UniqueId(),
      interestedId: UniqueId(),
      lastMessage: MessageContent('Hello'),
      lastMessageDate: DateTime.now(),
      dateCreated: PastDate(DateTime.now()),
    );
