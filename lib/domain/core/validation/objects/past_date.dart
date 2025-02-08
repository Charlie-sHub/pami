import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/converters/date_only_datetime.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_past_date.dart';

/// A value object representing a date in the past
class PastDate extends ValueObject<DateTime> {
  const PastDate._(this.value);

  /// Creates a new [PastDate]
  factory PastDate(DateTime input) => PastDate._(
        dateOnlyDateTime(input).flatMap(validatePastDate),
      );

  @override
  final Either<Failure<DateTime>, DateTime> value;

  @override
  List<Either> get props => [value];
}
