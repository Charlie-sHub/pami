import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/notifications/notifications_repository_interface.dart';

part 'notification_actor_bloc.freezed.dart';

part 'notification_actor_event.dart';

part 'notification_actor_state.dart';

/// Notification actor bloc
@injectable
class NotificationActorBloc
    extends Bloc<NotificationActorEvent, NotificationActorState> {
  /// Default constructor
  NotificationActorBloc(
    this._repository,
  ) : super(const NotificationActorState.initial()) {
    on<_DeleteNotification>(_onDeleteNotification);
    on<_MarkAsRead>(_onMarkAsRead);
  }

  final NotificationRepositoryInterface _repository;

  Future<void> _onDeleteNotification(
    _DeleteNotification event,
    Emitter emit,
  ) async {
    emit(const NotificationActorState.actionInProgress());
    final failureOrUnit = await _repository.deleteNotification(
      event.notificationId,
    );
    emit(
      failureOrUnit.fold(
        NotificationActorState.deletionFailure,
        (_) => const NotificationActorState.deletionSuccess(),
      ),
    );
  }

  Future<void> _onMarkAsRead(_MarkAsRead event, Emitter emit) async {
    final failureOrUnit = await _repository.markAsRead(event.notificationId);
    emit(
      failureOrUnit.fold(
        (failure) => state,
        (_) => const NotificationActorState.readMarkSuccess(),
      ),
    );
  }
}
