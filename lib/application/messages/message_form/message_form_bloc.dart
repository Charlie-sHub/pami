import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/messages/messages_repository_interface.dart';

part 'message_form_bloc.freezed.dart';
part 'message_form_event.dart';
part 'message_form_state.dart';

/// Message form bloc
@injectable
class MessageFormBloc extends Bloc<MessageFormEvent, MessageFormState> {
  /// Default constructor
  MessageFormBloc(
    this._repository,
  ) : super(MessageFormState.initial()) {
    on<MessageFormEvent>(
      (event, emit) => switch (event) {
        _MessageChanged(:final message) => _handleMessageChanged(
            message,
            emit,
          ),
        _Submitted() => _handleSubmitted(emit),
      },
    );
  }

  final MessagesRepositoryInterface _repository;

  Future<void> _handleMessageChanged(String message, Emitter emit) async =>
      emit(
        state.copyWith(
          message: state.message.copyWith(
            content: MessageContent(message),
          ),
          failureOrSuccessOption: none(),
        ),
      );

  Future<void> _handleSubmitted(Emitter emit) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      ),
    );

    Either<Failure, Unit> failureOrUnit;
    if (state.message.isValid) {
      failureOrUnit = await _repository.sendMessage(state.message);
    } else {
      failureOrUnit = left(const Failure.emptyFields());
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        failureOrSuccessOption: some(failureOrUnit),
      ),
    );
  }
}
