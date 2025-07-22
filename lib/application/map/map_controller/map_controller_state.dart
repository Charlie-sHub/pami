part of 'map_controller_bloc.dart';

/// Map controller state
@freezed
sealed class MapControllerState with _$MapControllerState {
  /// Default constructor
  const factory MapControllerState({
    required Coordinates coordinates,
    required double zoom,
    required bool locationPermissionGranted,
    required Map<String, BitmapDescriptor> bitmapIcons,
    required bool initialized,
  }) = _MapControllerState;

  /// Initial state
  factory MapControllerState.initial() => MapControllerState(
    coordinates: Coordinates.empty(),
    zoom: 15,
    locationPermissionGranted: false,
    bitmapIcons: const {},
    initialized: false,
  );
}
