import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates that two strings are the same
Either<Failure<String>, String> validateSameString(
  String firstInput,
  String secondInput,
) {
  if (firstInput.trim() == secondInput.trim()) {
    return right(firstInput);
  } else {
    return left(Failure.stringMismatch(failedValue: secondInput));
  }
}
