part of 'conversation_watcher_bloc.dart';

/// Conversations watcher event
@freezed
class ConversationWatcherEvent with _$ConversationWatcherEvent {
  /// Watch started event
  const factory ConversationWatcherEvent.watchStarted(
    UniqueId conversationId,
  ) = _Started;

  /// Messages received event
  const factory ConversationWatcherEvent.messagesReceived(
    Either<Failure, List<Message>> failureOrMessages,
  ) = _MessageReceived;
}
