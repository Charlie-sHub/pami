import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates a password
Either<Failure<String>, String> validatePassword(String input) {
  // A regex could be added to set password requirements, such as
  // having at least one number, mixing upper and lower case letters, etc.
  if (input.length >= 6) {
    return right(input);
  } else {
    return left(Failure.invalidPassword(failedValue: input));
  }
}
