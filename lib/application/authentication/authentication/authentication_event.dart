part of 'authentication_bloc.dart';

/// Authentication event
@freezed
sealed class AuthenticationEvent with _$AuthenticationEvent {
  /// Checks if the user is authenticated
  const factory AuthenticationEvent.authenticationCheckRequested() =
      _AuthenticationCheckRequested;

  /// Logs in the user
  const factory AuthenticationEvent.loggedOut() = _LoggedOut;
}
