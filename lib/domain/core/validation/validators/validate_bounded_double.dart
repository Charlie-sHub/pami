import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';

/// Validates that an double is within a given range
/// For example latitude between -90 and 90 degrees
Either<ValueFailure<double>, double> validateBoundedDouble({
  required double input,
  required double max,
  double min = 0,
}) {
  if (input <= max && input >= min) {
    return right(input);
  } else {
    return left(ValueFailure.doubleOutOfBounds(failedValue: input));
  }
}
