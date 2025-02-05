import 'package:pami/domain/core/failures/failure.dart';

/// [Error] class that encapsulates a [Failure]
class UnexpectedValueError extends Error {
  /// Default constructor
  UnexpectedValueError(this.valueFailure);

  /// The [Failure] that caused the error
  final Failure<dynamic> valueFailure;

  @override
  String toString() {
    const explanation = 'Unexpected value from at a unrecoverable point';
    return Error.safeToString('$explanation: $valueFailure');
  }
}

/// [Error] class that indicates that the user is not authenticated
/// At a point the user should be
class UnAuthenticatedError extends Error {
  @override
  String toString() {
    const explanation = "Couldn't get the authenticated User "
        'at a point where only authenticated Users should be';
    return Error.safeToString(explanation);
  }
}
