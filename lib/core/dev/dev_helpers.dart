import 'package:pami/domain/core/entities/contact_message.dart';
import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/entities/karma.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/entities/notification.dart';
import 'package:pami/domain/core/entities/settings.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/contact_message_type.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/misc/enums/transaction_status.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Returns a valid [User] entity for development purposes.
User getValidUser() => User(
      id: UniqueId(),
      email: EmailAddress('test@test.test'),
      name: Name('test'),
      username: Name('@name'),
      bio: EntityDescription('test'),
      avatar: Url('https://www.test.test'),
      isVerified: false,
      karma: KarmaPercentage(0),
      interestedShoutOutIds: {UniqueId()},
      lastLogin: PastDate(DateTime.now()),
      dateCreated: PastDate(DateTime.now()),
    );

/// Returns a valid [ContactMessage] entity for development purposes.
ContactMessage getValidContactMessage() => ContactMessage(
      id: UniqueId(),
      senderId: UniqueId(),
      content: MessageContent('test'),
      type: ContactMessageType.other,
      dateCreated: PastDate(DateTime.now()),
    );

/// Returns a valid [Conversation] entity for development purposes.
Conversation getValidConversation() => Conversation(
      id: UniqueId(),
      shoutOutCreatorId: UniqueId(),
      interestedId: UniqueId(),
      lastMessage: MessageContent('Hello'),
      lastMessageDate: DateTime.now(),
      dateCreated: PastDate(DateTime.now()),
    );

/// Returns a valid [Coordinates] entity for development purposes.
Coordinates getValidCoordinates() => Coordinates(
      latitude: Latitude(43.26091324415964),
      longitude: Longitude(-2.9471570388382364),
    );

/// Returns a valid [Karma] entity for development purposes.
Karma getValidKarma() => Karma(
      id: UniqueId(),
      giverId: UniqueId(),
      transactionId: UniqueId(),
      isPositive: true,
      dateCreated: PastDate(DateTime.now()),
    );

/// Returns a valid [MapSettings] entity for development purposes.
MapSettings getValidMapSettings() => MapSettings(
      radius: MapRadius(0),
      type: ShoutOutType.request,
      categories: {Category.food},
    );

/// Returns a valid [Message] entity for development purposes.
Message getValidMessage() => Message(
      id: UniqueId(),
      senderId: UniqueId(),
      content: MessageContent('test'),
      isRead: false,
      dateCreated: PastDate(DateTime.now()),
    );

/// Returns a valid [Notification] entity for development purposes.
Notification getValidNotification() => Notification(
      id: UniqueId(),
      recipientId: UniqueId(),
      description: EntityDescription('test'),
      seen: true,
      dateCreated: PastDate(DateTime.now()),
    );

/// Returns a valid [ShoutOut] entity for development purposes.
ShoutOut getValidShoutOut() {
  final id = UniqueId();
  return ShoutOut(
    id: id,
    creatorId: UniqueId(),
    type: ShoutOutType.offer,
    title: Name('test'),
    description: EntityDescription('test'),
    coordinates: getValidCoordinates(),
    duration: Minutes(0),
    categories: {Category.food},
    imageUrls: {Url('https://www.test.test')},
    isOpen: true,
    dateCreated: PastDate(DateTime.now()),
    qrCode: QrCode.fromData(
      data: id.getOrCrash(),
      errorCorrectLevel: QrErrorCorrectLevel.M,
    ),
  );
}

/// Returns a valid [Transaction] entity for development purposes.
Transaction getValidTransaction() => Transaction(
      id: UniqueId(),
      shoutOutCreatorId: UniqueId(),
      interestedId: UniqueId(),
      status: TransactionStatus.confirmed,
      dateCreated: PastDate(DateTime.now()),
    );

/// Returns a valid [Settings] entity for development purposes.
Settings getValidSettings() => const Settings(
      notificationsEnabled: true,
    );
