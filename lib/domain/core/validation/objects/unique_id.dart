import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/value_object.dart';
import 'package:uuid/uuid.dart';

/// A value object representing a unique identifier.
class UniqueId extends ValueObject<String> {
  const UniqueId._(this.value);

  /// Creates a new [UniqueId]
  factory UniqueId() => UniqueId._(right(const Uuid().v1()));

  /// Creates a new [UniqueId] from a assumed unique string
  factory UniqueId.fromUniqueString(String uniqueId) => UniqueId._(
        right(uniqueId),
      );
  @override
  final Either<Failure<String>, String> value;

  @override
  List<Object> get props => [value];
}
