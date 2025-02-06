import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Validates that a collection does not exceed a given length
Either<Failure<Iterable<T>>, Iterable<T>> validateMaxLengthIterable<T>({
  required Iterable<T> input,
  required int maxLength,
}) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(
      Failure.collectionExceedsLength(
        failedValue: input,
        maxLength: maxLength,
      ),
    );
  }
}
