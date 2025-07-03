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
import 'package:pami/domain/core/validation/objects/field_confirmator.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/password.dart';

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
    on<_Initialized>(_onInitialized);
    on<_ImageChanged>(_onImageChanged);
    on<_NameChanged>(_onNameChanged);
    on<_UsernameChanged>(_onUsernameChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_PasswordConfirmationChanged>(_onPasswordConfirmationChanged);
    on<_EmailAddressChanged>(_onEmailChanged);
    on<_EmailConfirmationChanged>(_onEmailConfirmationChanged);
    on<_BioChanged>(_onBioChanged);
    on<_TappedEULA>(_onTappedEULA);
    on<_Submitted>(_onSubmitted);
  }

  final AuthenticationRepositoryInterface _repository;

  void _onInitialized(_Initialized event, Emitter emit) => emit(
    event.userOption.fold(
      () => state.copyWith(initialized: true),
      (user) => state.copyWith(user: user, initialized: true),
    ),
  );

  void _onImageChanged(_ImageChanged event, Emitter emit) => emit(
    state.copyWith(
      imageFile: some(event.imageFile),
      failureOrSuccessOption: none(),
    ),
  );

  void _onNameChanged(_NameChanged event, Emitter emit) => emit(
    state.copyWith(
      user: state.user.copyWith(name: Name(event.name)),
      failureOrSuccessOption: none(),
    ),
  );

  void _onUsernameChanged(_UsernameChanged event, Emitter emit) => emit(
    state.copyWith(
      user: state.user.copyWith(username: Name(event.username)),
      failureOrSuccessOption: none(),
    ),
  );

  void _onPasswordChanged(_PasswordChanged event, Emitter emit) => emit(
    state.copyWith(
      password: Password(event.password),
      passwordConfirmator: FieldConfirmator(
        field: event.password,
        confirmation: state.passwordToCompare,
      ),
      failureOrSuccessOption: none(),
    ),
  );

  void _onPasswordConfirmationChanged(
    _PasswordConfirmationChanged event,
    Emitter emit,
  ) => emit(
    state.copyWith(
      passwordConfirmator: FieldConfirmator(
        field: state.password.value.fold((_) => '', id),
        confirmation: event.passwordConfirmation,
      ),
      passwordToCompare: event.passwordConfirmation,
      failureOrSuccessOption: none(),
    ),
  );

  void _onEmailChanged(_EmailAddressChanged event, Emitter emit) => emit(
    state.copyWith(
      user: state.user.copyWith(email: EmailAddress(event.email)),
      emailConfirmator: FieldConfirmator(
        field: event.email,
        confirmation: state.emailToCompare,
      ),
      failureOrSuccessOption: none(),
    ),
  );

  void _onEmailConfirmationChanged(
    _EmailConfirmationChanged event,
    Emitter emit,
  ) => emit(
    state.copyWith(
      emailConfirmator: FieldConfirmator(
        field: state.user.email.value.fold((_) => '', id),
        confirmation: event.emailConfirmation,
      ),
      emailToCompare: event.emailConfirmation,
      failureOrSuccessOption: none(),
    ),
  );

  void _onBioChanged(_BioChanged event, Emitter emit) => emit(
    state.copyWith(
      user: state.user.copyWith(bio: EntityDescription(event.bio)),
      failureOrSuccessOption: none(),
    ),
  );

  void _onTappedEULA(_, Emitter emit) => emit(
    state.copyWith(
      acceptedEULA: !state.acceptedEULA,
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

    Either<Failure, Unit>? result;
    final canRegister =
        state.user.isValid &&
            state.password.isValid() &&
            state.passwordConfirmator.isValid() &&
            state.emailConfirmator.isValid() ||
        state.acceptedEULA && state.imageFile.isSome();

    if (canRegister) {
      result = await _repository.register(
        user: state.user,
        password: state.password,
        imageFile: state.imageFile.getOrElse(
          () => XFile(''),
        ),
      );
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: !canRegister,
        failureOrSuccessOption: optionOf(result),
      ),
    );
  }
}
