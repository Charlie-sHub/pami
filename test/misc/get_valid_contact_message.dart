import 'package:pami/domain/core/entities/contact_message.dart';
import 'package:pami/domain/core/misc/enums/contact_message_type.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

ContactMessage getValidContactMessage() => ContactMessage(
      id: UniqueId(),
      senderId: UniqueId(),
      content: MessageContent('test'),
      type: ContactMessageType.other,
      dateCreated: PastDate(DateTime.now()),
    );
