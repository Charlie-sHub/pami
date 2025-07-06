import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/interested_shout_outs/interested_shout_outs_repository_interface.dart';

part 'interested_shout_outs_actor_bloc.freezed.dart';

part 'interested_shout_outs_actor_event.dart';

part 'interested_shout_outs_actor_state.dart';

/// Bloc for adding a ShoutOut to the interested list
@injectable
class InterestedShoutOutsActorBloc
    extends Bloc<InterestedShoutOutsActorEvent, InterestedShoutOutsActorState> {
  /// Default constructor
  InterestedShoutOutsActorBloc(
    this._repository,
  ) : super(const InterestedShoutOutsActorState.initial()) {
    on<_AddToInterested>(_onAddToInterested);
  }

  final InterestedShoutOutsRepositoryInterface _repository;

  Future<void> _onAddToInterested(_AddToInterested event, Emitter emit) async {
    emit(const InterestedShoutOutsActorState.actionInProgress());
    final failureOrSuccess = await _repository.addInterestedShoutOut(
      event.shoutOutId,
    );
    emit(
      failureOrSuccess.fold(
        InterestedShoutOutsActorState.additionFailure,
        (_) => const InterestedShoutOutsActorState.additionSuccess(),
      ),
    );
  }
}
