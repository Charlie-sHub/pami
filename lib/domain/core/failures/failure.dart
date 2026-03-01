/// Parent class for all failures.
abstract class Failure {
  /// Creates a new [Failure].
  const Failure();

  /// Returns a string representation of the failure.
  String get message;
}
