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
      (event, emit) => switch (event) {
        _Initialized() => _handleInitialized(emit),
        _ImageChanged(:final imageFile) => _handleImageChanged(imageFile, emit),
        _NameChanged(:final name) => _handleNameChanged(name, emit),
        _UsernameChanged(:final username) => _handleUsernameChanged(
            username,
            emit,
          ),
        _EmailAddressChanged(:final email) => _handleEmailAddressChanged(
            email,
            emit,
          ),
        _BioChanged(:final bio) => _handleBioChanged(bio, emit),
        _Submitted() => _handleSubmitted(emit),
      },
    );
  }

  final ProfileRepositoryInterface _repository;

  /// Gets the user
  User get user => state.userOption.getOrElse(User.empty);

  Future<void> _handleInitialized(Emitter emit) async {
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
  }

  void _handleImageChanged(XFile imageFile, Emitter emit) => emit(
        state.copyWith(
          imageFile: some(imageFile),
          failureOrSuccessOption: none(),
        ),
      );

  void _handleNameChanged(String name, Emitter emit) => emit(
        state.copyWith(
          userOption: some(
            user.copyWith(
              name: Name(name),
            ),
          ),
          failureOrSuccessOption: none(),
        ),
      );

  void _handleUsernameChanged(String username, Emitter emit) => emit(
        state.copyWith(
          userOption: some(
            user.copyWith(
              username: Name(username),
            ),
          ),
          failureOrSuccessOption: none(),
        ),
      );

  void _handleEmailAddressChanged(String email, Emitter emit) => emit(
        state.copyWith(
          userOption: some(
            user.copyWith(
              email: EmailAddress(email),
            ),
          ),
          failureOrSuccessOption: none(),
        ),
      );

  void _handleBioChanged(String bio, Emitter emit) => emit(
        state.copyWith(
          userOption: some(
            user.copyWith(
              bio: EntityDescription(bio),
            ),
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
    final canSubmit =
        user.isValid && (state.imageFile.isSome() || user.avatar.isValid());
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
  }
}
