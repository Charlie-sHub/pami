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
      (event, emit) => event.when(
        initialized: (type) => emit(
          state.copyWith(
            shoutOut: state.shoutOut.copyWith(type: type),
          ),
        ),
        titleChanged: (title) => emit(
          state.copyWith(
            shoutOut: state.shoutOut.copyWith(title: Name(title)),
          ),
        ),
        pictureChanged: (imageFile) => emit(
          state.copyWith(
            imageFile: some(imageFile),
          ),
        ),
        descriptionChanged: (description) => emit(
          state.copyWith(
            shoutOut: state.shoutOut.copyWith(
              description: EntityDescription(description),
            ),
          ),
        ),
        categoriesChanged: (categories) => emit(
          state.copyWith(
            shoutOut: state.shoutOut.copyWith(categories: categories),
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
          return null;
        },
      ),
    );
  }

  final ShoutOutManagementRepositoryInterface _repository;
}
