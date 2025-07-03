import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/shout_out_management/shout_out_management_repository_interface.dart';

part 'shout_out_creation_form_bloc.freezed.dart';

part 'shout_out_creation_form_event.dart';

part 'shout_out_creation_form_state.dart';

/// Shout out creation form bloc
@injectable
class ShoutOutCreationFormBloc
    extends Bloc<ShoutOutCreationFormEvent, ShoutOutCreationFormState> {
  /// Default constructor
  ShoutOutCreationFormBloc(
    this._repository,
  ) : super(ShoutOutCreationFormState.initial()) {
    on<_Initialized>(_onInitialized);
    on<_TitleChanged>(_onTitleChanged);
    on<_PictureChanged>(_onPictureChanged);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_CategoriesChanged>(_onCategoriesChanged);
    on<_Submitted>(_onSubmitted);
  }

  final ShoutOutManagementRepositoryInterface _repository;

  void _onInitialized(_Initialized event, Emitter emit) => emit(
    state.copyWith(
      shoutOut: state.shoutOut.copyWith(type: event.type),
    ),
  );

  void _onTitleChanged(_TitleChanged event, Emitter emit) => emit(
    state.copyWith(
      shoutOut: state.shoutOut.copyWith(title: Name(event.title)),
    ),
  );

  void _onPictureChanged(_PictureChanged event, Emitter emit) => emit(
    state.copyWith(
      imageFile: some(event.imageFile),
    ),
  );

  void _onDescriptionChanged(_DescriptionChanged event, Emitter emit) => emit(
    state.copyWith(
      shoutOut: state.shoutOut.copyWith(
        description: EntityDescription(event.description),
      ),
    ),
  );

  void _onCategoriesChanged(_CategoriesChanged event, Emitter emit) => emit(
    state.copyWith(
      shoutOut: state.shoutOut.copyWith(categories: event.categories),
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
    final canSubmit = state.shoutOut.isValid && state.imageFile.isSome();
    if (canSubmit) {
      final imageFile = state.imageFile.fold(
        () => null,
        (file) => file,
      );
      failureOrUnit = await _repository.createShoutOut(
        shoutOut: state.shoutOut,
        imageFile: imageFile!,
      );
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
