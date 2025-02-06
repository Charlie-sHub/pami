import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_bounded_double.dart';

/// A value object representing a percentage.
class KarmaPercentage extends ValueObject<double> {
  /// Creates a new [KarmaPercentage]
  factory KarmaPercentage(double input) => KarmaPercentage._(
        validateBoundedDouble(
          max: limit,
          input: input,
        ),
      );

  const KarmaPercentage._(this.value);

  /// Maximum percentage
  static const limit = 100.0;

  /// Returns the percentage as a double
  double get percentage => value.fold(
        (_) => 0.0,
        (value) => value,
      );

  /// Returns the left over percentage as a double
  double get leftPercentage => 100 - percentage;

  @override
  final Either<Failure<double>, double> value;

  @override
  List<Object> get props => [value];
}
