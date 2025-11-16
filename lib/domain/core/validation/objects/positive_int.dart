import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_bounded_int.dart';

/// A value object representing a positive integer.
class PositiveInt extends ValueObject<int> {
  const PositiveInt._(this.value);

  /// Creates a new [PositiveInt]
  factory PositiveInt(int input) => PositiveInt._(
    validateBoundedInteger(
      input: input,
    ),
  );

  @override
  final Either<Failure<int>, int> value;

  @override
  List<Object> get props => [value];
}
