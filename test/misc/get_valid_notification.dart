import 'package:pami/domain/core/entities/notification.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

Notification getValidNotification() => Notification(
      id: UniqueId(),
      recipientId: UniqueId(),
      description: EntityDescription('test'),
      seen: true,
      dateCreated: PastDate(DateTime.now()),
    );
