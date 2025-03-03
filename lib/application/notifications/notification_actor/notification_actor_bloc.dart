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
    on<NotificationActorEvent>(
      (event, emit) => switch (event) {
        _DeleteNotification(:final notificationId) => _handleDeleteNotification(
            notificationId,
            emit,
          ),
        _MarkAsRead(:final notificationId) => _handleMarkAsRead(
            notificationId,
            emit,
          ),
      },
    );
  }

  final NotificationRepositoryInterface _repository;

  Future<void> _handleDeleteNotification(
    UniqueId notificationId,
    Emitter emit,
  ) async {
    emit(const NotificationActorState.actionInProgress());
    final failureOrUnit = await _repository.deleteNotification(notificationId);
    emit(
      failureOrUnit.fold(
        NotificationActorState.deletionFailure,
        (_) => const NotificationActorState.deletionSuccess(),
      ),
    );
  }

  Future<void> _handleMarkAsRead(UniqueId notificationId, Emitter emit) async {
    final failureOrUnit = await _repository.markAsRead(notificationId);
    emit(
      failureOrUnit.fold(
        (failure) => state, // Keep previous state on failure
        (_) => const NotificationActorState.readMarkSuccess(),
      ),
    );
  }
}
