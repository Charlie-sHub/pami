part of 'contact_form_bloc.dart';

/// Contact form event
@freezed
class ContactFormEvent with _$ContactFormEvent {
  /// Message changed event
  const factory ContactFormEvent.messageChanged(
    String message,
  ) = _MessageChanged;

  /// Submitted event
  const factory ContactFormEvent.submitted() = _Submitted;
}
