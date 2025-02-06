import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_single_line_string.dart';
import 'package:pami/domain/core/validation/validators/validate_string_length.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing a description.
class NotificationContent extends ValueObject<String> {
  const NotificationContent._(this.value);

  /// Creates a new [NotificationContent]
  factory NotificationContent(String input) => NotificationContent._(
        validateStringLength(
          input: input,
          length: maxLength,
        ).flatMap(validateStringNotEmpty).flatMap(validateSingleLineString),
      );

  /// Maximum number of characters
  static const maxLength = 100;

  @override
  final Either<Failure<String>, String> value;

  @override
  List<Either> get props => [value];
}
