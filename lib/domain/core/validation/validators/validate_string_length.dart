import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';

/// Validates that a string does not exceed a given length
Either<ValueFailure<String>, String> validateStringLength({
  required String input,
  required int length,
}) {
  if (input.trim().length <= length) {
    return right(input);
  } else {
    return left(
      ValueFailure.stringExceedsLength(
        failedValue: input,
        maxLength: length,
      ),
    );
  }
}
