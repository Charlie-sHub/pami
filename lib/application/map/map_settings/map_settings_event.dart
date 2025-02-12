part of 'map_settings_bloc.dart';

/// Map settings event
@freezed
class MapSettingsEvent with _$MapSettingsEvent {
  /// Radius changed event
  const factory MapSettingsEvent.radiusChanged(
    double radius,
  ) = _RadiusChanged;

  /// Type changed event
  const factory MapSettingsEvent.typeChanged(
    ShoutOutType type,
  ) = _TypeChanged;

  /// Categories changed event
  const factory MapSettingsEvent.categoriesChanged(
    Set<Category> categories,
  ) = _CategoriesChanged;

  /// Reset settings event
  const factory MapSettingsEvent.resetSettings() = _ResetSettings;
}
