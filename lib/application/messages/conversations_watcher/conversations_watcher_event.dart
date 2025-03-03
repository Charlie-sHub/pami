part of 'conversations_watcher_bloc.dart';

/// Conversations watcher event
@freezed
sealed class ConversationsWatcherEvent with _$ConversationsWatcherEvent {
  /// Watch started event
  const factory ConversationsWatcherEvent.watchStarted(
    UniqueId shoutOutId,
  ) = _WatchStarted;

  /// Conversations received event
  const factory ConversationsWatcherEvent.conversationsReceived(
    Either<Failure, List<Conversation>> failureOrConversations,
  ) = _ConversationsReceived;
}
