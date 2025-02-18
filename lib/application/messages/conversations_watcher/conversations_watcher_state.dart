part of 'conversations_watcher_bloc.dart';

/// Conversations watcher state
@freezed
class ConversationsWatcherState with _$ConversationsWatcherState {
  /// Initial state
  const factory ConversationsWatcherState.initial() = _Initial;

  /// Action in progress state
  const factory ConversationsWatcherState.loadInProgress() = _LoadInProgress;

  /// Action success state
  const factory ConversationsWatcherState.loadSuccess(
    List<Conversation> conversations,
  ) = _LoadSuccess;

  /// Action failure state
  const factory ConversationsWatcherState.loadFailure(
    Failure failure,
  ) = _LoadFailure;
}
