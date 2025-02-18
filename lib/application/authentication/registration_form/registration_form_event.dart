part of 'registration_form_bloc.dart';

/// Registration form event
@freezed
class RegistrationFormEvent with _$RegistrationFormEvent {
  /// Initialized event
  const factory RegistrationFormEvent.initialized(
    Option<User> userOption,
  ) = _Initialized;

  /// Image changed event
  const factory RegistrationFormEvent.imageChanged(
    XFile imageFile,
  ) = _ImageChanged;

  /// Name changed event
  const factory RegistrationFormEvent.nameChanged(
    String name,
  ) = _NameChanged;

  /// Username changed event
  const factory RegistrationFormEvent.usernameChanged(
    String username,
  ) = _UsernameChanged;

  /// Password changed event
  const factory RegistrationFormEvent.passwordChanged(
    String password,
  ) = _PasswordChanged;

  /// Password confirmation changed event
  const factory RegistrationFormEvent.passwordConfirmationChanged(
    String passwordConfirmation,
  ) = _PasswordConfirmationChanged;

  /// Email address changed event
  const factory RegistrationFormEvent.emailAddressChanged(
    String email,
  ) = _EmailAddressChanged;

  /// Bio changed event
  const factory RegistrationFormEvent.bioChanged(
    String bio,
  ) = _BioChanged;

  /// Tapped EULA event
  const factory RegistrationFormEvent.tappedEULA() = _TappedEULA;

  /// Submitted event
  const factory RegistrationFormEvent.submitted() = _Submitted;
}
