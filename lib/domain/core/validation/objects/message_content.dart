import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_string_length.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing a message content.
class MessageContent extends ValueObject<String> {
  /// Creates a new [MessageContent]
  factory MessageContent(String input) => MessageContent._(
    validateStringLength(
      input: input,
      length: maxLength,
    ).flatMap(validateStringNotEmpty),
  );
  const MessageContent._(this.value);

  /// Maximum number of characters
  static const maxLength = 800;

  @override
  final Either<ValueFailure<String>, String> value;

  @override
  List<Either<ValueFailure<String>, String>> get props => [value];
}
