import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/messages/messages_repository_interface.dart';

/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: MessagesRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentMessagesRepository implements MessagesRepositoryInterface {
  /// Default constructor
  DevelopmentMessagesRepository(this._logger);

  final Logger _logger;

  @override
  Stream<Either<Failure, List<Conversation>>> watchConversations(
    UniqueId shoutOutId,
  ) {
    _logger.d(
      'Watching conversations for shout out: ${shoutOutId.getOrCrash()}',
    );

    final conversations = [
      getValidConversation(),
      getValidConversation().copyWith(
        id: UniqueId(),
      ),
    ];

    _logger.d(
      'Returning mock conversations: ${conversations.map(
        (conversation) => conversation.id,
      )}',
    );
    return Stream.value(right(conversations));
  }

  @override
  Stream<Either<Failure, List<Message>>> watchMessages(
    UniqueId conversationId,
  ) {
    _logger.d(
      'Watching messages for conversation: ${conversationId.getOrCrash()}',
    );

    final messages = [
      getValidMessage(),
      getValidMessage().copyWith(
        id: UniqueId(),
      ),
    ];

    _logger.d(
      'Returning mock messages: ${messages.map((message) => message.id)}',
    );
    return Stream.value(right(messages));
  }

  @override
  Future<Either<Failure, Unit>> sendMessage(Message message) async {
    _logger.d('Sending message: ${message.id.getOrCrash()} ');
    return right(unit);
  }
}
