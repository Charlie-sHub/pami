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
    on<_MessageChanged>(_onMessageChanged);
    on<_Submitted>(_onSubmitted);
  }

  final MessagesRepositoryInterface _repository;

  Future<void> _onMessageChanged(
    _MessageChanged event,
    Emitter emit,
  ) async => emit(
    state.copyWith(
      message: state.message.copyWith(
        content: MessageContent(event.message),
      ),
      failureOrSuccessOption: none(),
    ),
  );

  Future<void> _onSubmitted(_, Emitter emit) async {
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
        showErrorMessages: !state.message.isValid,
        failureOrSuccessOption: some(failureOrUnit),
      ),
    );
  }
}
