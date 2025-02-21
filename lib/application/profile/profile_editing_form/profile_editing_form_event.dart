part of 'profile_editing_form_bloc.dart';

/// Profile Editing form events
@freezed
class ProfileEditingFormEvent with _$ProfileEditingFormEvent {
  /// Initialized event
  const factory ProfileEditingFormEvent.initialized() = _Initialized;

  /// Name changed event
  const factory ProfileEditingFormEvent.nameChanged(
    String name,
  ) = _NameChanged;

  /// Username changed event
  const factory ProfileEditingFormEvent.usernameChanged(
    String username,
  ) = _UsernameChanged;

  /// Image changed event
  const factory ProfileEditingFormEvent.imageChanged(
    XFile imageFile,
  ) = _ImageChanged;

  /// Bio changed event
  const factory ProfileEditingFormEvent.bioChanged(
    String bio,
  ) = _BioChanged;

  /// Email address changed event
  const factory ProfileEditingFormEvent.emailAddressChanged(
    String emailAddress,
  ) = _EmailAddressChanged;

  /// Submit pressed event
  const factory ProfileEditingFormEvent.submitted() = _Submitted;
}
