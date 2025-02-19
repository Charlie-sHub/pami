import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/notification.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/notifications/notifications_repository_interface.dart';

part 'notifications_watcher_bloc.freezed.dart';
part 'notifications_watcher_event.dart';
part 'notifications_watcher_state.dart';

/// My shout outs watcher bloc
@injectable
class NotificationsWatcherBloc
    extends Bloc<NotificationsWatcherEvent, NotificationsWatcherState> {
  /// Default constructor
  NotificationsWatcherBloc(
    this._repository,
  ) : super(const NotificationsWatcherState.initial()) {
    on<NotificationsWatcherEvent>(
      (event, emit) => event.when(
        watchStarted: () async {
          emit(const NotificationsWatcherState.loadInProgress());
          await _streamSubscription?.cancel();
          _streamSubscription = _repository.watchNotifications().listen(
                (failureOrNotifications) => add(
                  NotificationsWatcherEvent.notificationsReceived(
                    failureOrNotifications,
                  ),
                ),
              );
          return null;
        },
        notificationsReceived: (result) => emit(
          result.fold(
            NotificationsWatcherState.loadFailure,
            NotificationsWatcherState.loadSuccess,
          ),
        ),
      ),
    );
  }

  final NotificationRepositoryInterface _repository;
  StreamSubscription<Either<Failure, List<Notification>>>? _streamSubscription;

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
