part of 'transaction_history_watcher_bloc.dart';

/// Transaction history state
@freezed
sealed class TransactionHistoryWatcherState
    with _$TransactionHistoryWatcherState {
  /// Initial state
  const factory TransactionHistoryWatcherState.initial() = Initial;

  /// Action in progress
  const factory TransactionHistoryWatcherState.loadInProgress() =
      LoadInProgress;

  /// Load success
  const factory TransactionHistoryWatcherState.loadSuccess(
    List<Transaction> transactions,
  ) = LoadSuccess;

  /// Load failure
  const factory TransactionHistoryWatcherState.loadFailure(
    Failure failure,
  ) = LoadFailure;
}
