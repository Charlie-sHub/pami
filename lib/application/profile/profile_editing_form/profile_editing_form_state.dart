part of 'profile_editing_form_bloc.dart';

/// Profile Editing form state
@freezed
abstract class ProfileEditingFormState with _$ProfileEditingFormState {
  /// Default constructor
  const factory ProfileEditingFormState({
    required Option<User> userOption,
    required Option<XFile> imageFile,
    required bool showErrorMessages,
    required bool initialized,
    required bool isSubmitting,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _ProfileEditingFormState;

  /// Initial state
  factory ProfileEditingFormState.initial() => ProfileEditingFormState(
        userOption: none(),
        imageFile: none(),
        showErrorMessages: false,
        initialized: false,
        isSubmitting: false,
        failureOrSuccessOption: none(),
      );
}
