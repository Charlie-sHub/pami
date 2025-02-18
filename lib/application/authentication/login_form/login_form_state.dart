part of 'login_form_bloc.dart';

/// Login form state
@freezed
class LoginFormState with _$LoginFormState {
  /// Default constructor
  const factory LoginFormState({
    required EmailAddress email,
    required Password password,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<User> thirdPartyUserOption,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _LoginFormState;

  /// Empty constructor
  factory LoginFormState.initial() => LoginFormState(
        email: EmailAddress(''),
        password: Password(''),
        showErrorMessages: false,
        isSubmitting: false,
        thirdPartyUserOption: none(),
        failureOrSuccessOption: none(),
      );
}
