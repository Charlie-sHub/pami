import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/map/map_repository_interface.dart';

part 'map_watcher_bloc.freezed.dart';
part 'map_watcher_event.dart';
part 'map_watcher_state.dart';

/// Map watcher bloc
@injectable
class MapWatcherBloc extends Bloc<MapWatcherEvent, MapWatcherState> {
  /// Default constructor
  MapWatcherBloc(this._mapRepository) : super(const MapWatcherState.initial()) {
    on<MapWatcherEvent>(
      (event, emit) => event.when(
        watchStarted: (settings) async {
          emit(const MapWatcherState.actionInProgress());
          await _streamSubscription?.cancel();
          _streamSubscription = _mapRepository.watchShoutOuts(settings).listen(
                (failureOrShoutOuts) => add(
                  MapWatcherEvent.resultsReceived(failureOrShoutOuts),
                ),
              );
          return null;
        },
        resultsReceived: (result) => emit(
          result.fold(
            MapWatcherState.loadFailure,
            MapWatcherState.loadSuccess,
          ),
        ),
      ),
    );
  }

  final MapRepositoryInterface _mapRepository;

  StreamSubscription<Either<Failure, Set<ShoutOut>>>? _streamSubscription;

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
