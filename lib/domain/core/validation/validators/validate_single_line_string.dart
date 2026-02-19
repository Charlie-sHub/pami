import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';

/// Validates that a string does not contain new lines
Either<ValueFailure<String>, String> validateSingleLineString(String input) {
  if (!input.contains('\n')) {
    return right(input);
  } else {
    return left(ValueFailure.multiLineString(failedValue: input));
  }
}
