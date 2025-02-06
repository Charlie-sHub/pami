import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_same_string.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing a password.
class PasswordConfirmator extends ValueObject<String> {
  const PasswordConfirmator._(this.value);

  /// Creates a new [PasswordConfirmator]
  factory PasswordConfirmator({
    required String password,
    required String confirmation,
  }) =>
      PasswordConfirmator._(
        validateSameString(
          password,
          confirmation,
        ).flatMap(validateStringNotEmpty),
      );

  @override
  final Either<Failure<String>, String> value;

  @override
  List<Either> get props => [value];
}
