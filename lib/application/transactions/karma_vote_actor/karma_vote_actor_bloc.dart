import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/transactions/transaction_repository_interface.dart';

part 'karma_vote_actor_bloc.freezed.dart';
part 'karma_vote_actor_event.dart';
part 'karma_vote_actor_state.dart';

/// Bloc for deleting submitting a karma vote
@injectable
class KarmaVoteActorBloc
    extends Bloc<KarmaVoteActorEvent, KarmaVoteActorState> {
  /// Default constructor.
  KarmaVoteActorBloc(
    this._repository,
  ) : super(const KarmaVoteActorState.initial()) {
    on<KarmaVoteActorEvent>(
      (event, emit) => event.when(
        voteSubmitted: (shoutOutId, isPositive) async {
          emit(const KarmaVoteActorState.actionInProgress());
          final failureOrSuccess = await _repository.submitKarmaVote(
            shoutOutId: shoutOutId,
            vote: isPositive,
          );
          emit(
            failureOrSuccess.fold(
              KarmaVoteActorState.voteFailure,
              (_) => const KarmaVoteActorState.voteSuccess(),
            ),
          );
          return null;
        },
      ),
    );
  }

  final TransactionRepositoryInterface _repository;
}
