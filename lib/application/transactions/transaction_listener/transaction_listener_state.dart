part of 'transaction_listener_bloc.dart';

/// Transaction listener state
@freezed
sealed class TransactionListenerState with _$TransactionListenerState {
  /// Initial state
  const factory TransactionListenerState.initial() = Initial;

  /// Loading state
  const factory TransactionListenerState.loadInProgress() = LoadInProgress;

  /// Successfully received shout-out update
  const factory TransactionListenerState.loadSuccess(
    Transaction transaction,
  ) = LoadSuccess;

  /// Failed to receive updates
  const factory TransactionListenerState.loadFailure(
    Failure failure,
  ) = LoadFailure;
}
