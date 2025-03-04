part of 'conversation_watcher_bloc.dart';

/// Conversations watcher event
@freezed
sealed class ConversationWatcherEvent with _$ConversationWatcherEvent {
  /// Watch started event
  const factory ConversationWatcherEvent.watchStarted(
    UniqueId conversationId,
  ) = _WatchStarted;

  /// Messages received event
  const factory ConversationWatcherEvent.messagesReceived(
    Either<Failure, List<Message>> failureOrMessages,
  ) = _MessagesReceived;
}
