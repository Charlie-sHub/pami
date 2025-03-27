part of 'map_controller_bloc.dart';

/// Map controller event
@freezed
sealed class MapControllerEvent with _$MapControllerEvent {
  /// Initializes the map controller
  const factory MapControllerEvent.initialized() = _Initialized;

  /// Changes the camera position of the map
  const factory MapControllerEvent.cameraPositionChanged({
    required Coordinates coordinates,
    required double zoom,
  }) = _CameraPositionChanged;

  /// Tracks the user’s location in real-time
  const factory MapControllerEvent.userLocationUpdated({
    required Either<Failure, Coordinates> result,
  }) = _UserLocationUpdated;

  /// Requests location permission
  const factory MapControllerEvent.locationPermissionRequested() =
      _LocationPermissionRequested;
}
