part of 'map_settings_bloc.dart';

/// Map settings state
@freezed
class MapSettingsState with _$MapSettingsState {
  /// Default constructor
  const factory MapSettingsState({
    required MapSettings settings,
  }) = _MapSettingsState;

  /// Empty constructor
  factory MapSettingsState.initial() => MapSettingsState(
        settings: MapSettings.empty(),
      );
}
