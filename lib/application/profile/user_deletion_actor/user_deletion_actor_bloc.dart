import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/profile/profile_repository_interface.dart';

part 'user_deletion_actor_bloc.freezed.dart';

part 'user_deletion_actor_event.dart';

part 'user_deletion_actor_state.dart';

/// Bloc for deleting a User.
@injectable
class UserDeletionActorBloc
    extends Bloc<UserDeletionActorEvent, UserDeletionActorState> {
  /// Default constructor.
  UserDeletionActorBloc(
    this._repository,
  ) : super(const UserDeletionActorState.initial()) {
    on<_DeleteRequested>(_onDeleteRequested);
  }

  final ProfileRepositoryInterface _repository;

  Future<void> _onDeleteRequested(_, Emitter emit) async {
    emit(const UserDeletionActorState.actionInProgress());
    final failureOrSuccess = await _repository.deleteUser();
    emit(
      failureOrSuccess.fold(
        UserDeletionActorState.deletionFailure,
        (_) => const UserDeletionActorState.deletionSuccess(),
      ),
    );
  }
}
