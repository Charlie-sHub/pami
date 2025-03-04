import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_password.dart';
import 'package:pami/domain/core/validation/validators/validate_single_line_string.dart';
import 'package:pami/domain/core/validation/validators/validate_string_length.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing a password.
class Password extends ValueObject<String> {
  /// Creates a new [Password]
  factory Password(String input) => Password._(
        validateStringLength(
          input: input,
          length: maxLength,
        )
            .flatMap(validateStringNotEmpty)
            .flatMap(validateSingleLineString)
            .flatMap(validatePassword),
      );

  const Password._(this.value);

  /// The maximum length of a password.
  static const maxLength = 40;

  @override
  final Either<Failure<String>, String> value;

  @override
  List<Either> get props => [value];
}
