import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/map/map_repository_interface.dart';
import 'package:permission_handler/permission_handler.dart';

part 'map_controller_bloc.freezed.dart';

part 'map_controller_event.dart';

part 'map_controller_state.dart';

/// Map controller bloc
@injectable
class MapControllerBloc extends Bloc<MapControllerEvent, MapControllerState> {
  /// Default constructor
  MapControllerBloc(
    this._repository,
  ) : super(MapControllerState.initial()) {
    on<_Initialized>(_onInitialized);
    on<_CameraPositionChanged>(_onCameraPositionChanged);
    on<_UserLocationUpdated>(_onUserLocationUpdated);
    on<_LocationPermissionRequested>(_onLocationPermissionRequested);
  }

  final MapRepositoryInterface _repository;
  StreamSubscription<Either<Failure, Coordinates>>? _userLocationSubscription;

  Future<void> _onInitialized(_, Emitter<MapControllerState> emit) async {
    final initialLocation = await _repository.getCurrentLocation();
    final bitmapIconsFuture = Future.wait(
      Category.values.map(
        (category) async {
          final asset = 'assets/images/markers/${category.name}.png';
          final icon = await BitmapDescriptor.asset(
            ImageConfiguration.empty,
            imagePixelRatio: 5,
            asset,
          );
          return MapEntry(category.name, icon);
        },
      ),
    ).then(Map.fromEntries);
    final bitmapIcons = await bitmapIconsFuture;

    emit(
      initialLocation.fold(
        (_) => state,
        (coordinates) => state.copyWith(
          coordinates: coordinates,
          bitmapIcons: bitmapIcons,
          initialized: true,
        ),
      ),
    );

    await _userLocationSubscription?.cancel();
    _userLocationSubscription = _repository.getUserLocationStream().listen(
      (result) => add(
        MapControllerEvent.userLocationUpdated(result: result),
      ),
    );
  }

  void _onCameraPositionChanged(_CameraPositionChanged event, Emitter emit) =>
      emit(
        state.copyWith(
          coordinates: event.coordinates,
          zoom: event.zoom,
        ),
      );

  void _onUserLocationUpdated(_UserLocationUpdated event, Emitter emit) => emit(
    event.result.fold(
      (_) => state,
      (coordinates) => state.copyWith(
        coordinates: coordinates,
      ),
    ),
  );

  Future<void> _onLocationPermissionRequested(_, Emitter emit) async {
    final status = await Permission.location.request();
    final granted = status.isGranted;

    emit(
      state.copyWith(locationPermissionGranted: granted),
    );

    if (granted) {
      add(const MapControllerEvent.initialized());
    }
  }

  @override
  Future<void> close() async {
    await _userLocationSubscription?.cancel();
    return super.close();
  }
}
