import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/value_failure.dart';

/// A value object representing a date without time.
Either<ValueFailure<DateTime>, DateTime> dateOnlyDateTime(DateTime dateTime) {
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
  return right(date);
}
