import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/authentication/authentication_repository_interface.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/password.dart';

part 'login_form_bloc.freezed.dart';
part 'login_form_event.dart';
part 'login_form_state.dart';

/// Login form bloc
@injectable
class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  /// Default constructor
  LoginFormBloc(this._repository) : super(LoginFormState.initial()) {
    on<LoginFormEvent>(
      (event, emit) => event.when(
        emailChanged: (emailString) => emit(
          state.copyWith(
            email: EmailAddress(emailString),
            failureOrSuccessOption: none(),
          ),
        ),
        passwordChanged: (passwordString) => emit(
          state.copyWith(
            password: Password(passwordString),
            failureOrSuccessOption: none(),
          ),
        ),
        loggedIn: () async {
          final isEmailValid = state.email.isValid();
          final isPasswordValid = state.password.isValid();

          Either<Failure, Unit>? failureOrSuccess;

          if (isEmailValid && isPasswordValid) {
            emit(
              state.copyWith(
                isSubmitting: true,
                failureOrSuccessOption: none(),
              ),
            );
            failureOrSuccess = await _repository.logIn(
              email: state.email,
              password: state.password,
            );
          }
          emit(
            state.copyWith(
              isSubmitting: false,
              showErrorMessages: true,
              failureOrSuccessOption: optionOf(failureOrSuccess),
            ),
          );
          return null;
        },
        loggedInGoogle: () => _performActionOnThirdPartyLogin(
          forwardedCall: _repository.logInGoogle,
          emitter: emit,
        ),
        loggedInApple: () => _performActionOnThirdPartyLogin(
          forwardedCall: _repository.logInApple,
          emitter: emit,
        ),
      ),
    );
  }

  final AuthenticationRepositoryInterface _repository;

  Future<void> _performActionOnThirdPartyLogin({
    required Future<Either<Failure, Option<User>>> Function() forwardedCall,
    required Emitter<LoginFormState> emitter,
  }) async {
    emitter(
      state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      ),
    );
    final failureOrSuccess = await forwardedCall();
    emitter(
      failureOrSuccess.fold(
        (failure) => state.copyWith(
          isSubmitting: false,
          failureOrSuccessOption: some(left(failure)),
        ),
        (userOption) => state.copyWith(
          isSubmitting: false,
          thirdPartyUserOption: userOption,
          failureOrSuccessOption: none(),
        ),
      ),
    );
  }
}
