import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_max_length_set.dart';

/// A value object representing a set of [Url]s.
class ImageUrlSet extends ValueObject<Set<Url>> {
  /// Creates a new [ImageUrlSet]
  factory ImageUrlSet(Set<Url> input) => ImageUrlSet._(
        validateMaxLengthSet(
          input: input,
          maxLength: maxLength,
        ),
      );

  const ImageUrlSet._(this.value);

  @override
  final Either<Failure<Set<Url>>, Set<Url>> value;

  /// Maximum number of [Url]s
  static const maxLength = 5;

  @override
  Either<Failure<dynamic>, Unit> get failureOrUnit => value.fold(
        left,
        (_) => right(unit),
      );

  /// Returns the number of [Url]s in the set
  int get length => value.getOrElse(() => const <Url>{}).length;

  /// Returns true if the set is full
  bool get isFull => length == maxLength;

  /// Returns true if the set is empty
  bool get isEmpty => value.getOrElse(() => const <Url>{}).isEmpty;

  /// Returns true if the set is not empty
  bool get isNotEmpty => value.getOrElse(() => const <Url>{}).isNotEmpty;

  @override
  List<Object> get props => [value];
}
