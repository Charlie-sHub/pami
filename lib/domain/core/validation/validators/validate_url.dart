import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';

/// Validates that a string is a valid URL based on the provided regex rules.
Either<ValueFailure<String>, String> validateUrl(String input) {
  final urlRegex = RegExp(
    r'^(https?:\/\/)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$',
    caseSensitive: false,
  );

  if (urlRegex.hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidUrl(failedValue: input));
  }
}
