import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_password.dart';
import 'package:pami/domain/core/validation/validators/validate_single_line_string.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing a password.
class Password extends ValueObject<String> {
  const Password._(this.value);

  /// Creates a new [Password]
  factory Password(String input) => Password._(
        validateStringNotEmpty(
          input,
        ).flatMap(validateSingleLineString).flatMap(validatePassword),
      );

  @override
  final Either<Failure<String>, String> value;

  @override
  List<Either> get props => [value];
}
