import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_string_length.dart';
import 'package:pami/domain/core/validation/validators/validate_string_not_empty.dart';

/// A value object representing a message content.
class MessageContent extends ValueObject<String> {
  const MessageContent._(this.value);

  /// Creates a new [MessageContent]
  factory MessageContent(String input) => MessageContent._(
        validateStringLength(
          input: input,
          length: maxLength,
        ).flatMap(validateStringNotEmpty),
      );

  /// Maximum number of characters
  static const maxLength = 400;

  @override
  final Either<Failure<String>, String> value;

  @override
  List<Either> get props => [value];
}
