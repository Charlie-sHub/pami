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
    on<_EmailChanged>(_onEmailChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_LoggedIn>(_onLoggedIn);
    on<_LoggedInGoogle>(_onLoggedInGoogle);
    on<_LoggedInApple>(_onLoggedInApple);
    on<_ResetThirdPartyUser>(_onResetThirdPartyUser);
  }

  final AuthenticationRepositoryInterface _repository;

  void _onEmailChanged(_EmailChanged event, Emitter emit) => emit(
    state.copyWith(
      email: EmailAddress(event.email),
      failureOrSuccessOption: none(),
    ),
  );

  void _onPasswordChanged(_PasswordChanged event, Emitter emit) => emit(
    state.copyWith(
      password: Password(event.password),
      failureOrSuccessOption: none(),
    ),
  );

  Future<void> _onLoggedIn(_, Emitter emit) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      ),
    );

    Either<Failure, Unit>? failureOrUnit;
    final canSubmit = state.email.isValid() && state.password.isValid();
    if (canSubmit) {
      failureOrUnit = await _repository.logIn(
        email: state.email,
        password: state.password,
      );
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: !canSubmit,
        failureOrSuccessOption: optionOf(failureOrUnit),
      ),
    );
  }

  Future<void> _onLoggedInGoogle(_, Emitter emit) async =>
      _performActionOnThirdPartyLogin(
        forwardedCall: _repository.logInGoogle,
        emit: emit,
      );

  Future<void> _onLoggedInApple(_, Emitter emit) async =>
      _performActionOnThirdPartyLogin(
        forwardedCall: _repository.logInApple,
        emit: emit,
      );

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

  void _onResetThirdPartyUser(_, Emitter emit) => emit(
    state.copyWith(
      thirdPartyUserOption: none(),
    ),
  );
}
