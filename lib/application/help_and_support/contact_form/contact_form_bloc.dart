import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/contact_message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/contact_message_type.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/help_and_support/help_and_support_repository_interface.dart';

part 'contact_form_bloc.freezed.dart';
part 'contact_form_event.dart';
part 'contact_form_state.dart';

/// Contact form bloc
@injectable
class ContactFormBloc extends Bloc<ContactFormEvent, ContactFormState> {
  /// Default constructor
  ContactFormBloc(
    this._repository,
  ) : super(ContactFormState.initial()) {
    on<ContactFormEvent>(
      (event, emit) => switch (event) {
        _TypeChanged(:final type) => _handleTypeChanged(type, emit),
        _MessageChanged(:final message) => _handleMessageChanged(message, emit),
        _Submitted() => _handleSubmitted(emit),
      },
    );
  }

  final HelpAndSupportRepositoryInterface _repository;

  void _handleTypeChanged(ContactMessageType type, Emitter emit) => emit(
        state.copyWith(
          message: state.message.copyWith(
            type: type,
          ),
          failureOrSuccessOption: none(),
        ),
      );

  void _handleMessageChanged(String message, Emitter emit) => emit(
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
      failureOrUnit = await _repository.submitContact(state.message);
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
