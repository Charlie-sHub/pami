import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/interested_shout_outs/interested_shout_outs_repository_interface.dart';

part 'interested_shout_outs_watcher_bloc.freezed.dart';
part 'interested_shout_outs_watcher_event.dart';
part 'interested_shout_outs_watcher_state.dart';

/// Interested shout outs watcher bloc
@injectable
class InterestedShoutOutsWatcherBloc extends Bloc<
    InterestedShoutOutsWatcherEvent, InterestedShoutOutsWatcherState> {
  /// Default constructor
  InterestedShoutOutsWatcherBloc(
    this._repository,
  ) : super(const InterestedShoutOutsWatcherState.initial()) {
    on<InterestedShoutOutsWatcherEvent>(
      (event, emit) => switch (event) {
        _WatchStarted() => _handleWatchStarted(emit),
        _ShoutOutsReceived(:final failureOrShoutOuts) =>
          _handleShoutOutsReceived(
            failureOrShoutOuts,
            emit,
          ),
      },
    );
  }

  final InterestedShoutOutsRepositoryInterface _repository;

  StreamSubscription<Either<Failure, Set<ShoutOut>>>? _streamSubscription;

  Future<void> _handleWatchStarted(Emitter emit) async {
    emit(const InterestedShoutOutsWatcherState.actionInProgress());
    await _streamSubscription?.cancel();
    _streamSubscription = _repository.watchInterestedShoutOuts().listen(
          (failureOrShoutOuts) => add(
            InterestedShoutOutsWatcherEvent.shoutOutsReceived(
              failureOrShoutOuts,
            ),
          ),
        );
  }

  void _handleShoutOutsReceived(
    Either<Failure, Set<ShoutOut>> result,
    Emitter emit,
  ) =>
      emit(
        result.fold(
          InterestedShoutOutsWatcherState.loadFailure,
          InterestedShoutOutsWatcherState.loadSuccess,
        ),
      );

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
