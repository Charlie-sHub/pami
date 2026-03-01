import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pami/domain/core/failures/failure.dart';

part 'app_failure.freezed.dart';

/// Represents infrastructure and application-level failures.
@freezed
sealed class AppFailure extends Failure with _$AppFailure {
  const AppFailure._();

  // --- Authentication / Domain-level app errors ---

  const factory AppFailure.notFoundError() = NotFoundError;

  const factory AppFailure.invalidCredentials() = InvalidCredentials;

  const factory AppFailure.unregisteredUser() = UnregisteredUser;

  const factory AppFailure.cancelledByUser() = CancelledByUser;

  const factory AppFailure.emailAlreadyInUse() = EmailAlreadyInUse;

  const factory AppFailure.usernameAlreadyInUse() = UsernameAlreadyInUse;

  const factory AppFailure.emptyFields() = EmptyFields;

  // --- Infrastructure errors ---

  const factory AppFailure.serverError({
    required String errorString,
  }) = ServerError;

  const factory AppFailure.cacheError({
    required String errorString,
  }) = CacheError;

  // --- Unexpected errors ---

  const factory AppFailure.unexpectedError({
    required String errorMessage,
  }) = UnexpectedError;

  @override
  String get message => switch (this) {
    NotFoundError() => 'Requested item not found.',
    InvalidCredentials() => 'Invalid credentials. Please try again.',
    UnregisteredUser() => 'User not registered.',
    CancelledByUser() => 'Action cancelled by the user.',
    EmailAlreadyInUse() => 'Email is already in use.',
    UsernameAlreadyInUse() => 'Username is already taken.',
    ServerError(:final errorString) => 'Server error: $errorString',
    CacheError(:final errorString) => 'Cache error: $errorString',
    UnexpectedError(:final errorMessage) => 'Unexpected error: $errorMessage',
    EmptyFields() => 'Some required fields are empty.',
  };
}
