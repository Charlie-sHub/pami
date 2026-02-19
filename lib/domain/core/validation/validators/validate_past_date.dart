import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';

/// Validates that a date is in the past
Either<ValueFailure<DateTime>, DateTime> validatePastDate(DateTime input) {
  if (!DateTime.now().isBefore(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidDate(failedValue: input));
  }
}
