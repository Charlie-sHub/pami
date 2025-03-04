part of 'transaction_listener_bloc.dart';

/// Transaction listener event
@freezed
sealed class TransactionListenerEvent with _$TransactionListenerEvent {
  /// Start watching a shout-out for transaction updates
  const factory TransactionListenerEvent.listenShoutOutStarted(
    UniqueId shoutOutId,
  ) = _ListenShoutOutStarted;

  /// Shout-out updated event (includes transaction data)
  const factory TransactionListenerEvent.shoutOutUpdated(
    Either<Failure, Transaction> failureOrTransaction,
  ) = _ShoutOutUpdated;
}
