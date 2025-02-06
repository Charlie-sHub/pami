import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_single_line_string.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';
import 'package:pami/domain/core/validation/validators/validate_url.dart';

/// A value object representing a URL.
class Url extends ValueObject<String> {
  const Url._(this.value);

  /// Creates a new [Url]
  factory Url(String input) => Url._(
        validateStringNotEmpty(
          input,
        ).flatMap(validateSingleLineString).flatMap(validateUrl),
      );

  @override
  final Either<Failure<String>, String> value;

  @override
  List<Either> get props => [value];
}
