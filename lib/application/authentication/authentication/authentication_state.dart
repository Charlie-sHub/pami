part of 'authentication_bloc.dart';

/// Authentication state
@freezed
sealed class AuthenticationState with _$AuthenticationState {
  /// Initial state
  const factory AuthenticationState.initial() = Initial;

  /// Authenticated state
  const factory AuthenticationState.authenticated(User currentUser) =
      Authenticated;

  /// Unauthenticated state
  const factory AuthenticationState.unAuthenticated() = UnAuthenticated;
}
