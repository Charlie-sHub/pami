import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// [Failure] class that represents a failure in a value object
@freezed
sealed class Failure<T> with _$Failure<T> {
  // --- Value Failures (Validation Errors) ---
  /// [Failure] indicating an invalid date
  const factory Failure.invalidDate({
    required DateTime failedValue,
  }) = InvalidDate<T>;

  /// [Failure] indicating an invalid email
  const factory Failure.invalidEmail({
    required String failedValue,
  }) = InvalidEmail<T>;

  /// [Failure] indicating an invalid password
  const factory Failure.invalidPassword({
    required String failedValue,
  }) = InvalidPassword<T>;

  /// [Failure] indicating an invalid name
  const factory Failure.invalidName({
    required String failedValue,
  }) = InvalidName<T>;

  /// [Failure] indicating an empty string
  const factory Failure.emptyString({
    required String failedValue,
  }) = EmptyString<T>;

  /// [Failure] indicating a multi-line string
  const factory Failure.multiLineString({
    required String failedValue,
  }) = MultiLineString<T>;

  /// [Failure] indicating a string that does not match a given pattern
  const factory Failure.stringMismatch({
    required String failedValue,
  }) = StringMismatch<T>;

  /// [Failure] indicating a given double is out of bounds
  const factory Failure.doubleOutOfBounds({
    required double failedValue,
  }) = NumOutOfBounds<T>;

  /// [Failure] indicating invalid coordinates
  const factory Failure.invalidCoordinate({
    required double failedValue,
  }) = InvalidCoordinates<T>;

  /// [Failure] indicating an empty set
  const factory Failure.emptySet({
    required T failedValue,
  }) = EmptySet<T>;

  /// [Failure] indicating an empty list
  const factory Failure.emptyList({
    required T failedValue,
  }) = EmptyList<T>;

  /// [Failure] indicating a string that exceeds a given length
  const factory Failure.stringExceedsLength({
    required String failedValue,
    required int maxLength,
  }) = StringExceedsLength<T>;

  /// [Failure] indicating a collection that exceeds a given length
  const factory Failure.collectionExceedsLength({
    required T failedValue,
    required int maxLength,
  }) = CollectionExceedsLength<T>;

  /// [Failure] indicating an invalid url
  const factory Failure.invalidUrl({
    required String failedValue,
  }) = InvalidUrl<T>;

  /// [Failure] indicating empty fields of a form
  const factory Failure.emptyFields() = EmptyFields<T>;

  // ---  Failures (Server/Cache Errors) ---
  /// [Failure] indicating a not found error
  const factory Failure.notFoundError() = NotFoundError<T>;

  /// [Failure] indicating an invalid credentials error
  const factory Failure.invalidCredentials() = InvalidCredentials<T>;

  /// [Failure] indicating an unregistered user error
  const factory Failure.unregisteredUser() = UnregisteredUser<T>;

  /// [Failure] indicating a cancelled by user error
  const factory Failure.cancelledByUser() = CancelledByUser<T>;

  /// [Failure] indicating a server error
  const factory Failure.serverError({
    required String errorString,
  }) = ServerError<T>;

  /// [Failure] indicating a cache error
  const factory Failure.cacheError({
    required String errorString,
  }) = CacheError<T>;

  // --- Application Failures (Unexpected Errors) ---
  /// [Failure] indicating an unexpected error
  const factory Failure.unexpectedError({
    required String errorMessage,
  }) = UnexpectedError<T>;
}
