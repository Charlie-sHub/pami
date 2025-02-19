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
    on<MyShoutOutsWatcherEvent>(
      (event, emit) => event.when(
        watchStarted: () async {
          emit(const MyShoutOutsWatcherState.actionInProgress());
          await _streamSubscription?.cancel();
          _streamSubscription = _repository.watchMyShoutOuts().listen(
                (failureOrShoutOuts) => add(
                  MyShoutOutsWatcherEvent.shoutOutsReceived(
                    failureOrShoutOuts,
                  ),
                ),
              );
          return null;
        },
        shoutOutsReceived: (result) => emit(
          result.fold(
            MyShoutOutsWatcherState.loadFailure,
            MyShoutOutsWatcherState.loadSuccess,
          ),
        ),
      ),
    );
  }

  final MyShoutOutsRepositoryInterface _repository;

  StreamSubscription<Either<Failure, Set<ShoutOut>>>? _streamSubscription;

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
