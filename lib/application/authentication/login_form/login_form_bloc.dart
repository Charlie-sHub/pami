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
  LoginFormBloc(
    this._repository,
  ) : super(LoginFormState.initial()) {
    on<LoginFormEvent>(
      (event, emit) => switch (event) {
        _EmailChanged(:final email) => _handleEmailChanged(email, emit),
        _PasswordChanged(:final password) => _handlePasswordChanged(
            password,
            emit,
          ),
        _LoggedIn() => _handleLoggedIn(emit),
        _LoggedInGoogle() => _performActionOnThirdPartyLogin(
            forwardedCall: _repository.logInGoogle,
            emit: emit,
          ),
        _LoggedInApple() => _performActionOnThirdPartyLogin(
            forwardedCall: _repository.logInApple,
            emit: emit,
          ),
      },
    );
  }

  final AuthenticationRepositoryInterface _repository;

  void _handleEmailChanged(String emailString, Emitter emit) => emit(
        state.copyWith(
          email: EmailAddress(emailString),
          failureOrSuccessOption: none(),
        ),
      );

  void _handlePasswordChanged(String passwordString, Emitter emit) => emit(
        state.copyWith(
          password: Password(passwordString),
          failureOrSuccessOption: none(),
        ),
      );

  Future<void> _handleLoggedIn(Emitter emit) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      ),
    );
    Either<Failure, Unit>? failureOrUnit;
    if (state.email.isValid() && state.password.isValid()) {
      failureOrUnit = await _repository.logIn(
        email: state.email,
        password: state.password,
      );
    }
    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        failureOrSuccessOption: optionOf(failureOrUnit),
      ),
    );
  }

  Future<void> _performActionOnThirdPartyLogin({
    required Future<Either<Failure, Option<User>>> Function() forwardedCall,
    required Emitter emit,
  }) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      ),
    );

    final failureOrUserOption = await forwardedCall();

    emit(
      failureOrUserOption.fold(
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
