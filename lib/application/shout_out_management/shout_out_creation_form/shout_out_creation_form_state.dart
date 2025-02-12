part of 'shout_out_creation_form_bloc.dart';

/// Shout out creation form state
@freezed
class ShoutOutCreationFormState with _$ShoutOutCreationFormState {
  /// Default constructor
  const factory ShoutOutCreationFormState({
    required ShoutOut shoutOut,
    required Option<XFile> imageFile,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _State;

  /// Empty constructor
  factory ShoutOutCreationFormState.initial() => ShoutOutCreationFormState(
        shoutOut: ShoutOut.empty(),
        imageFile: none(),
        showErrorMessages: false,
        isSubmitting: false,
        failureOrSuccessOption: none(),
      );
}
