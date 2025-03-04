part of 'contact_form_bloc.dart';

/// Contact form event
@freezed
sealed class ContactFormEvent with _$ContactFormEvent {
  /// Type changed event
  const factory ContactFormEvent.typeChanged(
    ContactMessageType type,
  ) = _TypeChanged;

  /// Message changed event
  const factory ContactFormEvent.messageChanged(
    String message,
  ) = _MessageChanged;

  /// Submitted event
  const factory ContactFormEvent.submitted() = _Submitted;
}
