part of 'transaction_history_watcher_bloc.dart';

/// Transaction history watcher event
@freezed
sealed class TransactionHistoryWatcherEvent
    with _$TransactionHistoryWatcherEvent {
  /// Fetch transaction history for the given user
  const factory TransactionHistoryWatcherEvent.fetchTransactionHistory(
    UniqueId userId,
  ) = _FetchTransactionHistory;
}
