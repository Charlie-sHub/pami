import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/my_shout_outs/my_shout_outs_repository_interface.dart';

part 'my_shout_outs_watcher_bloc.freezed.dart';

part 'my_shout_outs_watcher_event.dart';

part 'my_shout_outs_watcher_state.dart';

/// My shout outs watcher bloc
@injectable
class MyShoutOutsWatcherBloc
    extends Bloc<MyShoutOutsWatcherEvent, MyShoutOutsWatcherState> {
  /// Default constructor
  MyShoutOutsWatcherBloc(
    this._repository,
  ) : super(const MyShoutOutsWatcherState.initial()) {
    on<_WatchStarted>(_onWatchStarted);
    on<_ResultsReceived>(_onResultsReceived);
  }

  final MyShoutOutsRepositoryInterface _repository;
  StreamSubscription<Either<Failure, Set<ShoutOut>>>? _streamSubscription;

  Future<void> _onWatchStarted(_, Emitter emit) async {
    emit(const MyShoutOutsWatcherState.actionInProgress());
    await _streamSubscription?.cancel();
    _streamSubscription = _repository.watchMyShoutOuts().listen(
      (failureOrShoutOuts) => add(
        MyShoutOutsWatcherEvent.resultsReceived(failureOrShoutOuts),
      ),
    );
  }

  Future<void> _onResultsReceived(
    _ResultsReceived event,
    Emitter emit,
  ) async => emit(
    event.result.fold(
      MyShoutOutsWatcherState.loadFailure,
      MyShoutOutsWatcherState.loadSuccess,
    ),
  );

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
