import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/map/map_repository_interface.dart';

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
    on<MapControllerEvent>(
      (event, emit) => switch (event) {
        _Initialized() => _handleInitialized(emit),
        _CameraPositionChanged(:final coordinates, :final zoom) =>
          _handleCameraPositionChanged(
            coordinates,
            zoom,
            emit,
          ),
        _UserLocationUpdated(:final result) => _handleUserLocationUpdated(
            result,
            emit,
          ),
      },
    );
  }

  final MapRepositoryInterface _repository;
  StreamSubscription<Either<Failure, Coordinates>>? _userLocationSubscription;

  Future<void> _handleInitialized(Emitter emit) async {
    final initialLocation = await _repository.getCurrentLocation();

    emit(
      initialLocation.fold(
        (_) => state,
        (coordinates) => state.copyWith(
          coordinates: coordinates,
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

  void _handleCameraPositionChanged(
    Coordinates coordinates,
    double zoom,
    Emitter emit,
  ) {
    emit(
      state.copyWith(
        coordinates: coordinates,
        zoom: zoom,
      ),
    );
  }

  void _handleUserLocationUpdated(
    Either<Failure, Coordinates> result,
    Emitter emit,
  ) {
    emit(
      result.fold(
        (_) => state,
        (coordinates) => state.copyWith(
          coordinates: coordinates,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _userLocationSubscription?.cancel();
    return super.close();
  }
}
