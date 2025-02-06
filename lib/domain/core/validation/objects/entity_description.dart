import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_string_length.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing an entity's description.
class EntityDescription extends ValueObject<String> {
  const EntityDescription._(this.value);

  /// Creates a new [EntityDescription]
  factory EntityDescription(String input) => EntityDescription._(
        validateStringLength(
          input: input,
          length: maxLength,
        ).flatMap(validateStringNotEmpty),
      );

  /// Maximum number of characters
  static const maxLength = 200;

  @override
  final Either<Failure<String>, String> value;

  @override
  List<Either> get props => [value];
}
