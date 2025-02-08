import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_email.dart';

/// A value object representing an email address.
class EmailAddress extends ValueObject<String> {
  const EmailAddress._(this.value);

  /// Creates a new [EmailAddress]
  factory EmailAddress(String input) => EmailAddress._(
        validateEmail(input),
      );

  @override
  final Either<Failure<String>, String> value;

  @override
  List<Either> get props => [value];
}
