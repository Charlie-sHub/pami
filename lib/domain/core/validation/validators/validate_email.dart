import 'package:dartz/dartz.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates an email address
Either<Failure<String>, String> validateEmail(String input) {
  if (EmailValidator.validate(input)) {
    return right(input);
  } else {
    return left(Failure.invalidEmail(failedValue: input));
  }
}
