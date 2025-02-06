import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// A value object representing a date without time.
Either<Failure<DateTime>, DateTime> dateOnlyDateTime(DateTime dateTime) {
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
  return right(date);
}
