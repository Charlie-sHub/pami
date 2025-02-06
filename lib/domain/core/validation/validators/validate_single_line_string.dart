import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates that a string does not contain new lines
Either<Failure<String>, String> validateSingleLineString(String input) {
  if (!input.contains('\n')) {
    return right(input);
  } else {
    return left(Failure.multiLineString(failedValue: input));
  }
}
