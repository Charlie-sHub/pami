part of 'contact_form_bloc.dart';

/// Contact form state
@freezed
class ContactFormState with _$ContactFormState {
  /// Contact form state
  const factory ContactFormState({
    required ContactMessage message,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _ContactFormState;

  /// Initial contact form state
  factory ContactFormState.initial() => ContactFormState(
        message: ContactMessage.empty(),
        showErrorMessages: false,
        isSubmitting: false,
        failureOrSuccessOption: none(),
      );
}
