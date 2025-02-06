import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates a password
Either<Failure<String>, String> validatePassword(String input) {
  // Regex to check for:
  // - At least 8 characters
  // - At least one uppercase letter
  // - At least one lowercase letter
  // - At least one number
  // - At least one special character
  final passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  if (passwordRegex.hasMatch(input)) {
    return right(input);
  } else {
    return left(Failure.invalidPassword(failedValue: input));
  }
}
