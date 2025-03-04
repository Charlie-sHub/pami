part of 'shout_out_creation_form_bloc.dart';

/// Shout out creation form event
@freezed
sealed class ShoutOutCreationFormEvent with _$ShoutOutCreationFormEvent {
  /// Initialized event
  const factory ShoutOutCreationFormEvent.initialized(
    ShoutOutType type,
  ) = _Initialized;

  /// Title changed event
  const factory ShoutOutCreationFormEvent.titleChanged(
    String title,
  ) = _TitleChanged;

  /// Picture changed event
  const factory ShoutOutCreationFormEvent.pictureChanged(
    XFile imageFile,
  ) = _PictureChanged;

  /// Description changed event
  const factory ShoutOutCreationFormEvent.descriptionChanged(
    String description,
  ) = _DescriptionChanged;

  /// Categories added event
  const factory ShoutOutCreationFormEvent.categoriesChanged(
    Set<Category> categories,
  ) = _CategoriesChanged;

  /// Submitted event
  const factory ShoutOutCreationFormEvent.submitted() = _Submitted;
}
