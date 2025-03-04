part of 'conversations_watcher_bloc.dart';

/// Conversations watcher state
@freezed
sealed class ConversationsWatcherState with _$ConversationsWatcherState {
  /// Initial state
  const factory ConversationsWatcherState.initial() = Initial;

  /// Action in progress state
  const factory ConversationsWatcherState.loadInProgress() = LoadInProgress;

  /// Action success state
  const factory ConversationsWatcherState.loadSuccess(
    List<Conversation> conversations,
  ) = LoadSuccess;

  /// Action failure state
  const factory ConversationsWatcherState.loadFailure(
    Failure failure,
  ) = LoadFailure;
}
