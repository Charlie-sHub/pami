import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_bounded_double.dart';

/// A value object representing a radius.
class MapRadius extends ValueObject<double> {
  /// Creates a new [MapRadius]
  factory MapRadius(double input) => MapRadius._(
    validateBoundedDouble(
      max: limit,
      input: input,
    ),
  );
  const MapRadius._(this.value);

  /// Maximum radius
  static const limit = 20.0;

  @override
  final Either<ValueFailure<double>, double> value;

  @override
  List<Object> get props => [value];
}
