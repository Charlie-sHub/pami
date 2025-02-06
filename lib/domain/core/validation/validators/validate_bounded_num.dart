import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates that an num is within a given range
/// For example latitude between -90 and 90 degrees
Either<Failure<num>, num> validateBoundedNum({
  required num input,
  required num max,
  num min = 0,
}) {
  if (input <= max && input >= min) {
    return right(input);
  } else {
    return left(Failure.numOutOfBounds(failedValue: input));
  }
}
