import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the messages repository
abstract class MessagesRepositoryInterface {
  /// Fetches the conversations of the given shout out by the given [id]
  Future<Either<Failure, List<Conversation>>> fetchConversations(
    UniqueId shoutOutId,
  );

  /// Fetches the messages for the given conversation
  Future<Either<Failure, List<Message>>> fetchMessagesForConversation(
    UniqueId id,
  );

  /// Sends a message to the given conversation
  Future<Either<Failure, Unit>> sendMessage(Message message);
}
