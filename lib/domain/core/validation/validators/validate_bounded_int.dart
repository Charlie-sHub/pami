import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates that an int is within a given range
Either<Failure<int>, int> validateBoundedInteger({
  required int input,
  int max = 100000,
  int min = 0,
}) {
  if (input <= max && input >= min) {
    return right(input);
  } else {
    return left(Failure.intOutOfBounds(failedValue: input));
  }
}
