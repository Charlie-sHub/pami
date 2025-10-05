import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/interested_shout_outs/interested_shout_outs_repository_interface.dart';

part 'interested_shout_outs_actor_bloc.freezed.dart';

part 'interested_shout_outs_actor_event.dart';

part 'interested_shout_outs_actor_state.dart';

/// Bloc for adding or dismissing a ShoutOut to the interested list
@injectable
class InterestedShoutOutsActorBloc
    extends Bloc<InterestedShoutOutsActorEvent, InterestedShoutOutsActorState> {
  /// Default constructor
  InterestedShoutOutsActorBloc(
    this._repository,
  ) : super(const InterestedShoutOutsActorState.initial()) {
    on<_AddToInterested>(_onAddToInterested);
    on<_DismissFromInterested>(_onDismissFromInterested);
    on<_ScanCompleted>(_onScanCompleted);
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

  Future<void> _onDismissFromInterested(
    _DismissFromInterested event,
    Emitter emit,
  ) async {
    emit(const InterestedShoutOutsActorState.actionInProgress());
    final failureOrSuccess = await _repository.dismissInterestedShoutOut(
      event.shoutOutId,
    );
    emit(
      failureOrSuccess.fold(
        InterestedShoutOutsActorState.dismissalFailure,
        (_) => const InterestedShoutOutsActorState.dismissalSuccess(),
      ),
    );
  }

  Future<void> _onScanCompleted(
    _ScanCompleted event,
    Emitter<InterestedShoutOutsActorState> emit,
  ) async {
    emit(const InterestedShoutOutsActorState.actionInProgress());

    final parsedId = UniqueId.fromUniqueString(event.payload.trim());

    if (event.shoutOutId.getOrCrash() != parsedId.getOrCrash()) {
      emit(
        InterestedShoutOutsActorState.scanFailure(
          Failure.invalidQr(failedValue: event.payload),
        ),
      );
    } else {
      final failureOrSuccess = await _repository.confirmScan(
        shoutOutId: event.shoutOutId,
        scannerUserId: parsedId,
        rawPayload: some(event.payload),
      );
      emit(
        failureOrSuccess.fold(
          InterestedShoutOutsActorState.scanFailure,
          (_) => const InterestedShoutOutsActorState.scanSuccess(),
        ),
      );
    }
  }
}
