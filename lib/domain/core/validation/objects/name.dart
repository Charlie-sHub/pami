import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_single_line_string.dart';
import 'package:pami/domain/core/validation/validators/validate_string_length.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing a name.
class Name extends ValueObject<String> {
  /// Creates a new [Name]
  factory Name(String input) => Name._(
    validateStringLength(
      input: input,
      length: maxLength,
    ).flatMap(validateStringNotEmpty).flatMap(validateSingleLineString),
  );
  const Name._(this.value);

  /// Maximum number of characters
  static const maxLength = 50;

  @override
  final Either<ValueFailure<String>, String> value;

  @override
  List<Either<ValueFailure<String>, String>> get props => [value];
}
