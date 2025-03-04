part of 'conversation_watcher_bloc.dart';

/// Conversations watcher event
@freezed
sealed class ConversationWatcherState with _$ConversationWatcherState {
  /// Initial state
  const factory ConversationWatcherState.initial() = Initial;

  /// Load in progress state
  const factory ConversationWatcherState.loadInProgress() = LoadInProgress;

  /// Load success state
  const factory ConversationWatcherState.loadSuccess(
      List<Message> messages,) = LoadSuccess;

  /// Load failure state
  const factory ConversationWatcherState.loadFailure(
      Failure failure,) = LoadFailure;
}
