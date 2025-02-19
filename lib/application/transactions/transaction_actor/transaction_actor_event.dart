part of 'transaction_actor_bloc.dart';

/// Transaction actor event
@freezed
class TransactionActorEvent with _$TransactionActorEvent {
  /// Event for creating a transaction when the QR code is scanned.
  const factory TransactionActorEvent.transactionCreated({
    required UniqueId shoutOutId,
  }) = _TransactionCreated;
}
