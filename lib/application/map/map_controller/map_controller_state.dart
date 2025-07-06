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
  }) = _MapControllerState;

  /// Initial state
  factory MapControllerState.initial() => MapControllerState(
    coordinates: Coordinates.empty(),
    zoom: 10,
    locationPermissionGranted: false,
    bitmapIcons: const {},
  );
}
