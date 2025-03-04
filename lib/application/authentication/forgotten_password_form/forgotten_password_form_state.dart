part of 'forgotten_password_form_bloc.dart';

/// Forgotten password form state
@freezed
abstract class ForgottenPasswordFormState with _$ForgottenPasswordFormState {
  /// Default constructor
  const factory ForgottenPasswordFormState({
    required EmailAddress email,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _ForgottenPasswordFormState;

  /// Empty constructor
  factory ForgottenPasswordFormState.initial() => ForgottenPasswordFormState(
        email: EmailAddress(''),
        showErrorMessages: false,
        isSubmitting: false,
        failureOrSuccessOption: none(),
      );
}
