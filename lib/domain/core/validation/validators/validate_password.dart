import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';

/// Validates a password
Either<ValueFailure<String>, String> validatePassword(String input) {
  // Regex to check for:
  // - At least 8 characters
  // - At least one uppercase letter
  // - At least one lowercase letter
  // - At least one number
  // - At least one special character
  final passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  if (passwordRegex.hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidPassword(failedValue: input));
  }
}
