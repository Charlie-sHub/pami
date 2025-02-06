import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates that a string is not empty
Either<Failure<String>, String> validateStringNotEmpty(String input) {
  if (input.trim().isNotEmpty) {
    return right(input);
  } else {
    return left(Failure.emptyString(failedValue: input));
  }
}
