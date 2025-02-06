import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_single_line_string.dart';
import 'package:pami/domain/core/validation/validators/validate_string_length.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing a name.
class Name extends ValueObject<String> {
  const Name._(this.value);

  /// Creates a new [Name]
  factory Name(String input) => Name._(
        validateStringLength(
          input: input,
          length: maxLength,
        ).flatMap(validateStringNotEmpty).flatMap(validateSingleLineString),
      );

  /// Maximum number of characters
  static const maxLength = 50;

  @override
  final Either<Failure<String>, String> value;

  @override
  List<Either> get props => [value];
}
