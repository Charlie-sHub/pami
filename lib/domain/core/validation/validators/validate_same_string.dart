import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';

/// Validates that two strings are the same
Either<ValueFailure<String>, String> validateSameString(
  String firstInput,
  String secondInput,
) {
  if (firstInput.trim() == secondInput.trim()) {
    return right(firstInput);
  } else {
    return left(ValueFailure.stringMismatch(failedValue: secondInput));
  }
}
