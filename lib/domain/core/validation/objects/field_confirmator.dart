import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_same_string.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing a Field.
class FieldConfirmator extends ValueObject<String> {
  const FieldConfirmator._(this.value);

  /// Creates a new [FieldConfirmator]
  factory FieldConfirmator({
    required String field,
    required String confirmation,
  }) => FieldConfirmator._(
    validateSameString(
      field,
      confirmation,
    ).flatMap(validateStringNotEmpty),
  );

  @override
  final Either<ValueFailure<String>, String> value;

  @override
  List<Either> get props => [value];
}
