import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/authentication/authentication_repository_interface.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/password.dart';
import 'package:pami/domain/core/validation/objects/password_confirmator.dart';

part 'registration_form_bloc.freezed.dart';
part 'registration_form_event.dart';
part 'registration_form_state.dart';

/// Registration form bloc
@injectable
class RegistrationFormBloc
    extends Bloc<RegistrationFormEvent, RegistrationFormState> {
  /// Default constructor
  RegistrationFormBloc(
    this._repository,
  ) : super(RegistrationFormState.initial()) {
    on<RegistrationFormEvent>(
      (event, emit) => switch (event) {
        _Initialized(:final userOption) => _handleInitialized(userOption, emit),
        _ImageChanged(:final imageFile) => _handleImageChanged(imageFile, emit),
        _NameChanged(:final name) => _handleNameChanged(name, emit),
        _UsernameChanged(:final username) => _handleUsernameChanged(
            username,
            emit,
          ),
        _PasswordChanged(:final password) => _handlePasswordChanged(
            password,
            emit,
          ),
        _PasswordConfirmationChanged(:final passwordConfirmation) =>
          _handlePasswordConfirmationChanged(
            passwordConfirmation,
            emit,
          ),
        _EmailAddressChanged(:final email) => _handleEmailChanged(email, emit),
        _BioChanged(:final bio) => _handleBioChanged(bio, emit),
        _TappedEULA() => _handleTappedEULA(emit),
        _Submitted() => _handleSubmitted(emit),
      },
    );
  }

  final AuthenticationRepositoryInterface _repository;

  void _handleInitialized(Option<User> userOption, Emitter emit) => emit(
        userOption.fold(
          () => state.copyWith(initialized: true),
          (user) => state.copyWith(user: user, initialized: true),
        ),
      );

  void _handleImageChanged(XFile imageFile, Emitter emit) => emit(
        state.copyWith(
          imageFile: some(imageFile),
          failureOrSuccessOption: none(),
        ),
      );

  void _handleNameChanged(String name, Emitter emit) => emit(
        state.copyWith(
          user: state.user.copyWith(name: Name(name)),
          failureOrSuccessOption: none(),
        ),
      );

  void _handleUsernameChanged(String username, Emitter emit) => emit(
        state.copyWith(
          user: state.user.copyWith(username: Name(username)),
          failureOrSuccessOption: none(),
        ),
      );

  void _handlePasswordChanged(String password, Emitter emit) => emit(
        state.copyWith(
          password: Password(password),
          passwordConfirmator: PasswordConfirmator(
            password: password,
            confirmation: state.passwordToCompare,
          ),
          failureOrSuccessOption: none(),
        ),
      );

  void _handlePasswordConfirmationChanged(String confirmation, Emitter emit) =>
      emit(
        state.copyWith(
          passwordConfirmator: PasswordConfirmator(
            password: state.password.value.fold((_) => '', id),
            confirmation: confirmation,
          ),
          passwordToCompare: confirmation,
          failureOrSuccessOption: none(),
        ),
      );

  void _handleEmailChanged(String email, Emitter emit) => emit(
        state.copyWith(
          user: state.user.copyWith(email: EmailAddress(email)),
          failureOrSuccessOption: none(),
        ),
      );

  void _handleBioChanged(String bio, Emitter emit) => emit(
        state.copyWith(
          user: state.user.copyWith(bio: EntityDescription(bio)),
          failureOrSuccessOption: none(),
        ),
      );

  void _handleTappedEULA(Emitter emit) => emit(
        state.copyWith(
          acceptedEULA: !state.acceptedEULA,
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
    Either<Failure, Unit>? failureOrUnit;
    final canRegister = state.user.isValid &&
        state.password.isValid() &&
        state.passwordConfirmator.isValid() &&
        state.acceptedEULA &&
        (state.imageFile.isSome());
    if (canRegister) {
      failureOrUnit = await _repository.register(
        user: state.user,
        password: state.password,
        imageFile: state.imageFile.getOrElse(
          () => XFile(''),
        ),
      );
    } else {
      failureOrUnit = left(const Failure.emptyFields());
    }
    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        failureOrSuccessOption: optionOf(failureOrUnit),
      ),
    );
  }
}
