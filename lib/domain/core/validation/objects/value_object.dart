import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/error.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Base class for all value objects
@immutable
abstract class ValueObject<T> extends Equatable {
  /// Default constructor
  const ValueObject();

  /// Gets the [Failure] or the [value] if it's valid
  Either<Failure<dynamic>, Unit> get failureOrUnit => value.fold(
        left,
        (_) => right(unit),
      );

  /// Gets the value of the object
  Either<Failure<T>, T> get value;

  /// Whether the value is valid or not
  bool isValid() => value.isRight();

  @override
  String toString() => value.fold(
        (failure) => failure.toString(),
        (value) => '$value',
      );

  /// Throws [UnexpectedValueError] containing the [Failure]
  /// if it can't get the proper value
  T getOrCrash() => value.fold(
        (valueFailure) => throw UnexpectedValueError(valueFailure),
        id,
      );

  /// Returns the [Failure] or throws [Error]
  Failure<T> failureOrCrash() => value.fold(
        id,
        (value) => throw Error(),
      );
}
