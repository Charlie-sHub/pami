/// Transaction status
enum TransactionStatus {
  /// Initial state when offer is created
  pending,

  /// After QR scan
  confirmed,

  /// After karma vote
  completed,

  /// If either party cancels
  cancelled
}
