import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates that a date is in the past
Either<Failure<DateTime>, DateTime> validatePastDate(DateTime input) {
  if (!DateTime.now().isBefore(input)) {
    return right(input);
  } else {
    return left(Failure.invalidDate(failedValue: input));
  }
}
