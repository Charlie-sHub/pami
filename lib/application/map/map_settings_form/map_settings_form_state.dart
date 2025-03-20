part of 'map_settings_form_bloc.dart';

/// Map settings state
@freezed
sealed class MapSettingsFormState with _$MapSettingsFormState {
  /// Default constructor
  const factory MapSettingsFormState({
    required MapSettings settings,
  }) = _MapSettingsFormState;

  /// Empty constructor
  factory MapSettingsFormState.initial() => MapSettingsFormState(
        settings: MapSettings.empty().copyWith(
          radius: MapRadius(10),
        ),
      );
}
