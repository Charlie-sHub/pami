import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

import 'package:pami/domain/core/failures/value_failure.dart';

/// Validates that a collection does not exceed a given length
Either<ValueFailure<Set<T>>, Set<T>> validateMaxLengthSet<T>({
  required Set<T> input,
  required int maxLength,
}) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(
      ValueFailure.collectionExceedsLength(
        failedValue: input,
        maxLength: maxLength,
      ),
    );
  }
}
