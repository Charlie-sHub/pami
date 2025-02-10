part of 'authentication_bloc.dart';

/// Authentication state
@freezed
class AuthenticationState with _$AuthenticationState {
  /// Initial state
  const factory AuthenticationState.initial() = _Initial;

  /// Authenticated state
  const factory AuthenticationState.authenticated(User currentUser) =
      _Authenticated;

  /// Unauthenticated state
  const factory AuthenticationState.unAuthenticated() = _UnAuthenticated;
}
