part of 'transaction_listener_bloc.dart';

/// Transaction listener state
@freezed
class TransactionListenerState with _$TransactionListenerState {
  /// Initial state
  const factory TransactionListenerState.initial() = _Initial;

  /// Loading state
  const factory TransactionListenerState.loadInProgress() = _LoadInProgress;

  /// Successfully received shout-out update
  const factory TransactionListenerState.loadSuccess(
    Transaction transaction,
  ) = _LoadSuccess;

  /// Failed to receive updates
  const factory TransactionListenerState.loadFailure(
    Failure failure,
  ) = _LoadFailure;
}
