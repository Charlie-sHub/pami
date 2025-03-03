part of 'message_form_bloc.dart';

/// Message form state
@freezed
sealed class MessageFormState with _$MessageFormState {
  /// Default constructor
  const factory MessageFormState({
    required Message message,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _MessageFormState;

  /// Initial state
  factory MessageFormState.initial() => MessageFormState(
        message: Message.empty(),
        showErrorMessages: false,
        isSubmitting: false,
        failureOrSuccessOption: none(),
      );
}
