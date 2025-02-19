import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/transactions/transaction_repository_interface.dart';

part 'transaction_actor_bloc.freezed.dart';
part 'transaction_actor_event.dart';
part 'transaction_actor_state.dart';

/// Bloc for creating a transaction
@injectable
class TransactionActorBloc
    extends Bloc<TransactionActorEvent, TransactionActorState> {
  /// Default constructor.
  TransactionActorBloc(
    this._repository,
  ) : super(const TransactionActorState.initial()) {
    on<TransactionActorEvent>(
      (event, emit) => event.when(
        transactionCreated: (shoutOutId) async {
          emit(const TransactionActorState.actionInProgress());
          final failureOrSuccess = await _repository.createTransaction(
            shoutOutId,
          );
          emit(
            failureOrSuccess.fold(
              TransactionActorState.transactionFailure,
              (_) => TransactionActorState.transactionSuccess(shoutOutId),
            ),
          );
          return null;
        },
      ),
    );
  }

  final TransactionRepositoryInterface _repository;
}
