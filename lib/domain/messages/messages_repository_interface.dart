import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/failures/app_failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the messages repository
abstract class MessagesRepositoryInterface {
  /// Fetches the conversations of the given shout out by the given [id]
  Stream<Either<AppFailure, List<Conversation>>> watchConversations(
    UniqueId shoutOutId,
  );

  /// Fetches the messages for the given conversation
  Stream<Either<AppFailure, List<Message>>> watchMessages(
    UniqueId conversationId,
  );

  /// Sends a message to the given conversation
  Future<Either<AppFailure, Unit>> sendMessage(Message message);
}
