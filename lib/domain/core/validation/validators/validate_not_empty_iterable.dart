import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates that a collection is not empty
Either<Failure<Iterable<T>>, Iterable<T>> validateNotEmptyIterable<T>(
  Iterable<T> input,
) {
  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(Failure.emptyList(failedValue: input));
  }
}
