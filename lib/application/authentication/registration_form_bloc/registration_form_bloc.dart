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
  RegistrationFormBloc(this._repository)
      : super(RegistrationFormState.initial()) {
    on<RegistrationFormEvent>(
      (event, emit) => event.when(
        initialized: (userOption) => emit(
          userOption.fold(
            () => state.copyWith(
              initialized: true,
            ),
            (user) => state.copyWith(
              user: user,
              initialized: true,
            ),
          ),
        ),
        imageChanged: (imageFile) => emit(
          state.copyWith(
            imageFile: some(imageFile),
            failureOrSuccessOption: none(),
          ),
        ),
        nameChanged: (name) => emit(
          state.copyWith(
            user: state.user.copyWith(
              name: Name(name),
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        usernameChanged: (username) => emit(
          state.copyWith(
            user: state.user.copyWith(
              username: Name(username),
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        passwordChanged: (password) => emit(
          state.copyWith(
            password: Password(password),
            passwordConfirmator: PasswordConfirmator(
              password: password,
              confirmation: state.passwordToCompare,
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        passwordConfirmationChanged: (passwordConfirmation) => emit(
          state.copyWith(
            passwordConfirmator: PasswordConfirmator(
              password: state.password.value.fold(
                (failure) => '',
                id,
              ),
              confirmation: passwordConfirmation,
            ),
            passwordToCompare: passwordConfirmation,
            failureOrSuccessOption: none(),
          ),
        ),
        emailAddressChanged: (email) => emit(
          state.copyWith(
            user: state.user.copyWith(
              email: EmailAddress(email),
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        bioChanged: (bio) => emit(
          state.copyWith(
            user: state.user.copyWith(
              bio: EntityDescription(bio),
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        tappedEULA: () => emit(
          state.copyWith(
            acceptedEULA: !state.acceptedEULA,
            failureOrSuccessOption: none(),
          ),
        ),
        submitted: () async {
          Either<Failure, Unit>? failureOrUnit;
          emit(
            state.copyWith(
              isSubmitting: true,
              failureOrSuccessOption: none(),
            ),
          );
          final canRegister = state.user.isValid &&
              state.password.isValid() &&
              state.passwordConfirmator.isValid() &&
              state.acceptedEULA &&
              (state.imageFile.isSome() || state.user.avatar.isValid());
          if (canRegister) {
            failureOrUnit = await _repository.register(
              user: state.user,
              password: state.password,
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
          return null;
        },
      ),
    );
  }

  final AuthenticationRepositoryInterface _repository;
}
