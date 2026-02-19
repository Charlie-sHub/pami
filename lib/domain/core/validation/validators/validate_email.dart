import 'package:dartz/dartz.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pami/domain/core/failures/failure.dart';

import 'package:pami/domain/core/failures/value_failure.dart';

/// Validates an email address
Either<ValueFailure<String>, String> validateEmail(String input) {
  if (EmailValidator.validate(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}
