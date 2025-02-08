import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_bounded_double.dart';

/// A value object representing a radius.
class MapRadius extends ValueObject<double> {
  const MapRadius._(this.value);

  /// Creates a new [MapRadius]
  factory MapRadius(double input) => MapRadius._(
        validateBoundedDouble(
          max: limit,
          input: input,
        ),
      );

  /// Maximum radius
  static const limit = 20.0;

  @override
  final Either<Failure<double>, double> value;

  @override
  List<Object> get props => [value];
}
