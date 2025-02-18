part of 'login_form_bloc.dart';

/// Login form event
@freezed
class LoginFormEvent with _$LoginFormEvent {
  /// Email changed event
  const factory LoginFormEvent.emailChanged(String email) = _EmailChanged;

  /// Password changed event
  const factory LoginFormEvent.passwordChanged(String password) =
      _PasswordChanged;

  /// Submit event
  const factory LoginFormEvent.loggedIn() = _LoggedIn;

  /// Logged in via Google
  const factory LoginFormEvent.loggedInGoogle() = _LoggedInGoogle;

  /// Logged in via Apple
  const factory LoginFormEvent.loggedInApple() = _LoggedInApple;
}
