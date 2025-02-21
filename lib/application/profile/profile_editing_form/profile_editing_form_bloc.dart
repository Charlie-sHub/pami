import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/profile/profile_repository_interface.dart';

part 'profile_editing_form_bloc.freezed.dart';
part 'profile_editing_form_event.dart';
part 'profile_editing_form_state.dart';

/// ProfileEditing form bloc
@injectable
class ProfileEditingFormBloc
    extends Bloc<ProfileEditingFormEvent, ProfileEditingFormState> {
  /// Default constructor
  ProfileEditingFormBloc(
    this._repository,
  ) : super(ProfileEditingFormState.initial()) {
    on<ProfileEditingFormEvent>(
      (event, emit) => event.when(
        initialized: () async {
          final failureOrUnit = await _repository.getCurrentUser();
          emit(
            failureOrUnit.fold(
              (failure) => state.copyWith(
                userOption: none(),
                failureOrSuccessOption: some(left(failure)),
                initialized: true,
              ),
              (user) => state.copyWith(
                userOption: some(user),
                initialized: true,
              ),
            ),
          );
          return null;
        },
        imageChanged: (imageFile) => emit(
          state.copyWith(
            imageFile: some(imageFile),
            failureOrSuccessOption: none(),
          ),
        ),
        nameChanged: (name) => emit(
          state.copyWith(
            userOption: some(
              user.copyWith(
                name: Name(name),
              ),
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        usernameChanged: (username) => emit(
          state.copyWith(
            userOption: some(
              user.copyWith(
                username: Name(username),
              ),
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        emailAddressChanged: (email) => emit(
          state.copyWith(
            userOption: some(
              user.copyWith(
                email: EmailAddress(email),
              ),
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        bioChanged: (bio) => emit(
          state.copyWith(
            userOption: some(
              user.copyWith(
                bio: EntityDescription(bio),
              ),
            ),
            failureOrSuccessOption: none(),
          ),
        ),
        submitted: () async {
          emit(
            state.copyWith(
              isSubmitting: true,
              failureOrSuccessOption: none(),
            ),
          );
          Either<Failure, Unit>? failureOrUnit;
          final canSubmit = user.isValid &&
              (state.imageFile.isSome() || user.avatar.isValid());
          if (canSubmit) {
            failureOrUnit = await _repository.updateUserProfile(user);
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

  final ProfileRepositoryInterface _repository;

  /// Gets the user
  User get user => state.userOption.getOrElse(User.empty);
}
