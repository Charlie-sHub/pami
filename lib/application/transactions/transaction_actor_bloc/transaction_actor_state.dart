part of 'transaction_actor_bloc.dart';

/// Transaction actor state
@freezed
class TransactionActorState with _$TransactionActorState {
  /// Initial state
  const factory TransactionActorState.initial() = _Initial;

  /// Transaction creation in progress
  const factory TransactionActorState.actionInProgress() = _ActionInProgress;

  /// Transaction creation successful
  const factory TransactionActorState.transactionSuccess(
    UniqueId shoutOutId,
  ) = _TransactionSuccess;

  /// Transaction creation failed
  const factory TransactionActorState.transactionFailure(
    Failure failure,
  ) = _TransactionFailure;
}
