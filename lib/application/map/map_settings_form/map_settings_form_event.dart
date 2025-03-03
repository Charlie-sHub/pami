part of 'map_settings_form_bloc.dart';

/// Map settings event
@freezed
sealed class MapSettingsFormEvent with _$MapSettingsFormEvent {
  /// Radius changed event
  const factory MapSettingsFormEvent.radiusChanged(
    double radius,
  ) = _RadiusChanged;

  /// Type changed event
  const factory MapSettingsFormEvent.typeChanged(
    ShoutOutType type,
  ) = _TypeChanged;

  /// Categories changed event
  const factory MapSettingsFormEvent.categoriesChanged(
    Set<Category> categories,
  ) = _CategoriesChanged;

  /// Reset settings event
  const factory MapSettingsFormEvent.resetSettings() = _ResetSettings;
}
