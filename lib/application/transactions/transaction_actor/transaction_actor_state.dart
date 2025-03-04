part of 'transaction_actor_bloc.dart';

/// Transaction actor state
@freezed
sealed class TransactionActorState with _$TransactionActorState {
  /// Initial state
  const factory TransactionActorState.initial() = Initial;

  /// Transaction creation in progress
  const factory TransactionActorState.actionInProgress() = ActionInProgress;

  /// Transaction creation successful
  const factory TransactionActorState.transactionSuccess(
    UniqueId shoutOutId,
  ) = TransactionSuccess;

  /// Transaction creation failed
  const factory TransactionActorState.transactionFailure(
    Failure failure,
  ) = TransactionFailure;
}
