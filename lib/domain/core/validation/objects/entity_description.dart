import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_string_length.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing an entity's description.
class EntityDescription extends ValueObject<String> {
  /// Creates a new [EntityDescription]
  factory EntityDescription(String input) => EntityDescription._(
    validateStringLength(
      input: input,
      length: maxLength,
    ).flatMap(validateStringNotEmpty),
  );
  const EntityDescription._(this.value);

  /// Maximum number of characters
  static const maxLength = 200;

  @override
  final Either<ValueFailure<String>, String> value;

  @override
  List<Either<ValueFailure<String>, String>> get props => [value];
}
