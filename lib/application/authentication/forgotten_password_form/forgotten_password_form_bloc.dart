import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/authentication/authentication_repository_interface.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';

part 'forgotten_password_form_bloc.freezed.dart';

part 'forgotten_password_form_event.dart';

part 'forgotten_password_form_state.dart';

/// Forgotten password form bloc
@injectable
class ForgottenPasswordFormBloc
    extends Bloc<ForgottenPasswordFormEvent, ForgottenPasswordFormState> {
  /// Default constructor
  ForgottenPasswordFormBloc(
    this._repository,
  ) : super(ForgottenPasswordFormState.initial()) {
    on<_EmailChanged>(_onEmailChanged);
    on<_Submitted>(_onSubmitted);
  }

  final AuthenticationRepositoryInterface _repository;

  void _onEmailChanged(_EmailChanged event, Emitter emit) => emit(
    state.copyWith(
      email: EmailAddress(event.email),
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

    Either<Failure, Unit>? failureOrUnit;
    if (state.email.isValid()) {
      failureOrUnit = await _repository.resetPassword(state.email);
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: !state.email.isValid(),
        failureOrSuccessOption: optionOf(failureOrUnit),
      ),
    );
  }
}
