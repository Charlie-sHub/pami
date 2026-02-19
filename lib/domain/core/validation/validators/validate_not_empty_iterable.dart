import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';

/// Validates that a collection is not empty
Either<ValueFailure<Iterable<T>>, Iterable<T>> validateNotEmptyIterable<T>(
  Iterable<T> input,
) {
  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(ValueFailure.emptyList(failedValue: input));
  }
}
