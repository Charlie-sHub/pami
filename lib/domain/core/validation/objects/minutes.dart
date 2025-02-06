import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_bounded_double.dart';

/// A value object representing minutes.
class Minutes extends ValueObject<double> {
  /// Creates a new [Minutes]
  factory Minutes(double input) => Minutes._(
        validateBoundedDouble(
          max: limit,
          input: input,
        ),
      );

  const Minutes._(this.value);

  /// Maximum amount of minutes
  static const limit = 1440.0;

  @override
  final Either<Failure<double>, double> value;

  @override
  List<Object> get props => [value];
}
