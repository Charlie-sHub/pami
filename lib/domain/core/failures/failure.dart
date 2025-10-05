import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// [Failure] class that represents a failure in a value object
@freezed
sealed class Failure<T> with _$Failure<T> {
  const Failure._();

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

  /// [Failure] indicating an invalid QR code
  const factory Failure.invalidQr({
    required String failedValue,
  }) = InvalidQr<T>;

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

  /// [Failure] indicating an email already in use error
  const factory Failure.emailAlreadyInUse() = EmailAlreadyInUse<T>;

  /// [Failure] indicating a username already in use error
  const factory Failure.usernameAlreadyInUse() = UsernameAlreadyInUse<T>;

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

  /// Returns a string representation of the failure
  String get message =>
      switch (this) {
        InvalidDate(:final failedValue) => 'Invalid date: $failedValue',
        InvalidEmail(:final failedValue) => 'Invalid email: $failedValue',
        InvalidPassword() => 'Invalid password format.',
        InvalidName(:final failedValue) => 'Invalid name: $failedValue',
        EmptyString() => 'This field cannot be empty.',
        MultiLineString() => 'This field must be a single line.',
        StringMismatch(:final failedValue) => 'Invalid format: $failedValue',
        NumOutOfBounds(:final failedValue) =>
        'Value is out of bounds: $failedValue',
        InvalidCoordinates(:final failedValue) =>
        'Invalid coordinate: $failedValue',
        EmptySet() => 'Selection cannot be empty.',
        EmptyList() => 'List cannot be empty.',
        StringExceedsLength(:final maxLength) =>
        'Text exceeds maximum length of $maxLength characters.',
        CollectionExceedsLength(:final maxLength) =>
        'Collection exceeds maximum length of $maxLength items.',
        InvalidUrl(:final failedValue) => 'Invalid URL: $failedValue',
        InvalidQr(:final failedValue) => 'Invalid QR code: $failedValue',
        EmptyFields() => 'Some required fields are empty.',
        NotFoundError() => 'Requested item not found.',
        InvalidCredentials() => 'Invalid credentials. Please try again.',
        UnregisteredUser() => 'User not registered.',
        CancelledByUser() => 'Action cancelled by the user.',
        EmailAlreadyInUse() => 'Email is already in use.',
        UsernameAlreadyInUse() => 'Username is already taken.',
        ServerError(:final errorString) => 'Server error: $errorString',
        CacheError(:final errorString) => 'Cache error: $errorString',
        UnexpectedError(:final errorMessage) =>
        'An unexpected error occurred: $errorMessage',
      };
}
