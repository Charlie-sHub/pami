part of 'message_form_bloc.dart';

/// Message form event
@freezed
sealed class MessageFormEvent with _$MessageFormEvent {
  /// Message changed event
  const factory MessageFormEvent.messageChanged(
    String message,
  ) = _MessageChanged;

  /// Submitted event
  const factory MessageFormEvent.submitted() = _Submitted;
}
