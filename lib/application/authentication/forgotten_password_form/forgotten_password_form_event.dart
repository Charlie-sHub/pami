part of 'forgotten_password_form_bloc.dart';

/// Forgotten password form event
@freezed
class ForgottenPasswordFormEvent with _$ForgottenPasswordFormEvent {
  /// Email changed event
  const factory ForgottenPasswordFormEvent.emailChanged(String email) =
      _EmailChanged;

  /// Submitted event
  const factory ForgottenPasswordFormEvent.submitted() = _Submitted;
}
