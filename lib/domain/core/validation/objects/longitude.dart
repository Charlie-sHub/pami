import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_bounded_double.dart';

/// A value object representing a longitude.
class Longitude extends ValueObject<double> {
  const Longitude._(this.value);

  /// Creates a new [Longitude]
  factory Longitude(double input) => Longitude._(
        validateBoundedDouble(
          max: limit,
          min: -limit,
          input: input,
        ),
      );

  /// Maximum latitude
  static const limit = 180.0;

  @override
  final Either<Failure<double>, double> value;

  @override
  List<Object> get props => [value];
}
