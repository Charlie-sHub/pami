import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:pami/domain/core/validation/validators/validate_max_length_set.dart';

/// A value object representing a set of categories.
class CategorySet extends ValueObject<Set<Category>> {
  const CategorySet._(this.value);

  /// Creates a new [CategorySet]
  factory CategorySet(Set<Category> input) => CategorySet._(
        validateMaxLengthSet(
          input: input,
          maxLength: maxLength,
        ),
      );

  @override
  final Either<Failure<Set<Category>>, Set<Category>> value;

  /// Maximum number of categories
  static const maxLength = 5;

  /// Returns the number of categories in the set
  int get length => value.getOrElse(() => const <Category>{}).length;

  /// Returns true if the set is full
  bool get isFull => length == maxLength;

  /// Returns true if the set is empty
  bool get isEmpty => value.getOrElse(() => const <Category>{}).isEmpty;

  /// Returns true if the set is not empty
  bool get isNotEmpty => value.getOrElse(() => const <Category>{}).isNotEmpty;

  @override
  List<Object> get props => [value];
}
