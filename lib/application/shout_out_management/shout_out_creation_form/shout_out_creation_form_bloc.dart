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
    on<ShoutOutCreationFormEvent>(
      (event, emit) => switch (event) {
        _Initialized(:final type) => _handleInitialized(type, emit),
        _TitleChanged(:final title) => _handleTitleChanged(title, emit),
        _PictureChanged(:final imageFile) => _handlePictureChanged(
            imageFile,
            emit,
          ),
        _DescriptionChanged(:final description) => _handleDescriptionChanged(
            description,
            emit,
          ),
        _CategoriesChanged(:final categories) => _handleCategoriesChanged(
            categories,
            emit,
          ),
        _Submitted() => _handleSubmitted(emit),
      },
    );
  }

  final ShoutOutManagementRepositoryInterface _repository;

  void _handleInitialized(ShoutOutType type, Emitter emit) => emit(
        state.copyWith(
          shoutOut: state.shoutOut.copyWith(type: type),
        ),
      );

  void _handleTitleChanged(String title, Emitter emit) => emit(
        state.copyWith(
          shoutOut: state.shoutOut.copyWith(title: Name(title)),
        ),
      );

  void _handlePictureChanged(XFile imageFile, Emitter emit) => emit(
        state.copyWith(
          imageFile: some(imageFile),
        ),
      );

  void _handleDescriptionChanged(String description, Emitter emit) => emit(
        state.copyWith(
          shoutOut: state.shoutOut.copyWith(
            description: EntityDescription(description),
          ),
        ),
      );

  void _handleCategoriesChanged(Set<Category> categories, Emitter emit) => emit(
        state.copyWith(
          shoutOut: state.shoutOut.copyWith(categories: categories),
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
    if (state.shoutOut.isValid && state.imageFile.isSome()) {
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
        showErrorMessages: true,
        failureOrSuccessOption: optionOf(failureOrUnit),
      ),
    );
  }
}
