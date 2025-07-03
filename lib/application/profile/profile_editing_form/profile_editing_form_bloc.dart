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
    on<_Initialized>(_onInitialized);
    on<_ImageChanged>(_onImageChanged);
    on<_NameChanged>(_onNameChanged);
    on<_UsernameChanged>(_onUsernameChanged);
    on<_EmailChanged>(_onEmailChanged);
    on<_BioChanged>(_onBioChanged);
    on<_Submitted>(_onSubmitted);
  }

  final ProfileRepositoryInterface _repository;

  /// Gets the user
  User get user => state.userOption.getOrElse(User.empty);

  Future<void> _onInitialized(_, Emitter emit) async {
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

  void _onImageChanged(_ImageChanged event, Emitter emit) => emit(
    state.copyWith(
      imageFile: some(event.imageFile),
      failureOrSuccessOption: none(),
    ),
  );

  void _onNameChanged(_NameChanged event, Emitter emit) => emit(
    state.copyWith(
      userOption: some(
        user.copyWith(
          name: Name(event.name),
        ),
      ),
      failureOrSuccessOption: none(),
    ),
  );

  void _onUsernameChanged(_UsernameChanged event, Emitter emit) => emit(
    state.copyWith(
      userOption: some(
        user.copyWith(
          username: Name(event.username),
        ),
      ),
      failureOrSuccessOption: none(),
    ),
  );

  void _onEmailChanged(_EmailChanged event, Emitter emit) => emit(
    state.copyWith(
      userOption: some(
        user.copyWith(
          email: EmailAddress(event.email),
        ),
      ),
      failureOrSuccessOption: none(),
    ),
  );

  void _onBioChanged(_BioChanged event, Emitter emit) => emit(
    state.copyWith(
      userOption: some(
        user.copyWith(
          bio: EntityDescription(event.bio),
        ),
      ),
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

    Either<Failure, Unit> failureOrUnit;
    final hasValidImage = state.imageFile.isSome() || user.avatar.isValid();
    final canSubmit = user.isValid && hasValidImage;

    if (canSubmit) {
      failureOrUnit = await _repository.updateUserProfile(user);
    } else {
      failureOrUnit = left(const Failure.emptyFields());
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: !canSubmit,
        failureOrSuccessOption: optionOf(failureOrUnit),
      ),
    );
  }
}
