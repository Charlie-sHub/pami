part of 'conversation_watcher_bloc.dart';

/// Conversations watcher event
@freezed
class ConversationWatcherState with _$ConversationWatcherState {
  /// Initial state
  const factory ConversationWatcherState.initial() = _Initial;

  /// Load in progress state
  const factory ConversationWatcherState.loadInProgress() = _LoadInProgress;

  /// Load success state
  const factory ConversationWatcherState.loadSuccess(
    List<Message> messages,
  ) = _LoadSuccess;

  /// Load failure state
  const factory ConversationWatcherState.loadFailure(
    Failure failure,
  ) = _LoadFailure;
}
