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
  ForgottenPasswordFormBloc(this._repository)
      : super(ForgottenPasswordFormState.initial()) {
    on<ForgottenPasswordFormEvent>(
      (event, emit) => event.when(
        emailChanged: (email) => emit(
          state.copyWith(
            email: EmailAddress(email),
            failureOrSuccessOption: none(),
          ),
        ),
        submitted: () async {
          Either<Failure, Unit>? failureOrSuccess;
          if (state.email.isValid()) {
            emit(
              state.copyWith(
                isSubmitting: true,
                failureOrSuccessOption: none(),
              ),
            );
            failureOrSuccess = await _repository.resetPassword(state.email);
            emit(
              state.copyWith(
                isSubmitting: false,
                failureOrSuccessOption: some(failureOrSuccess),
              ),
            );
          } else {
            emit(
              state.copyWith(
                showErrorMessages: true,
                failureOrSuccessOption: some(
                  left(const Failure.emptyFields()),
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  final AuthenticationRepositoryInterface _repository;
}
