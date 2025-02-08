import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

Message getValidMessage() => Message(
      id: UniqueId(),
      senderId: UniqueId(),
      content: MessageContent('test'),
      isRead: false,
      dateCreated: PastDate(DateTime.now()),
    );
