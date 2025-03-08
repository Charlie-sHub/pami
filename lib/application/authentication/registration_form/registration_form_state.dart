part of 'registration_form_bloc.dart';

/// Registration form state
@freezed
abstract class RegistrationFormState with _$RegistrationFormState {
  /// Default constructor
  const factory RegistrationFormState({
    required User user,
    required FieldConfirmator emailConfirmator,
    required String emailToCompare,
    required Option<XFile> imageFile,
    required Password password,
    required FieldConfirmator passwordConfirmator,
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
        emailConfirmator: FieldConfirmator(
          field: '',
          confirmation: '',
        ),
        emailToCompare: '',
        imageFile: none(),
        password: Password(''),
        passwordConfirmator: FieldConfirmator(
          field: '',
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
