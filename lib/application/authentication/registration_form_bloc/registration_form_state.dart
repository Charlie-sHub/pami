part of 'registration_form_bloc.dart';

/// Registration form state
@freezed
class RegistrationFormState with _$RegistrationFormState {
  /// Default constructor
  const factory RegistrationFormState({
    required User user,
    required Option<XFile> imageFile,
    required Password password,
    required PasswordConfirmator passwordConfirmator,
    required String passwordToCompare,
    required bool showErrorMessages,
    required bool isSubmitting,
    required bool acceptedEULA,
    required bool initialized,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _RegistrationFormState;

  /// Empty constructor
  factory RegistrationFormState.initial() => RegistrationFormState(
        user: User.empty(),
        imageFile: none(),
        password: Password(''),
        passwordConfirmator: PasswordConfirmator(
          password: '',
          confirmation: '',
        ),
        passwordToCompare: '',
        showErrorMessages: false,
        isSubmitting: false,
        acceptedEULA: false,
        initialized: false,
        failureOrSuccessOption: none(),
      );
}
