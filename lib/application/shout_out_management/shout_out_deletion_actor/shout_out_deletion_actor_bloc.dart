import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/shout_out_management/shout_out_management_repository_interface.dart';

part 'shout_out_deletion_actor_bloc.freezed.dart';

part 'shout_out_deletion_actor_event.dart';

part 'shout_out_deletion_actor_state.dart';

/// Bloc for deleting a shout out.
@injectable
class ShoutOutDeletionActorBloc
    extends Bloc<ShoutOutDeletionActorEvent, ShoutOutDeletionActorState> {
  /// Default constructor.
  ShoutOutDeletionActorBloc(
    this._repository,
  ) : super(const ShoutOutDeletionActorState.initial()) {
    on<_DeleteRequested>(_onDeleteRequested);
  }

  final ShoutOutManagementRepositoryInterface _repository;

  Future<void> _onDeleteRequested(_DeleteRequested event, Emitter emit) async {
    emit(const ShoutOutDeletionActorState.actionInProgress());
    final failureOrSuccess = await _repository.deleteShoutOut(event.shoutOutId);
    emit(
      failureOrSuccess.fold(
        ShoutOutDeletionActorState.deletionFailure,
        (_) => const ShoutOutDeletionActorState.deletionSuccess(),
      ),
    );
  }
}
