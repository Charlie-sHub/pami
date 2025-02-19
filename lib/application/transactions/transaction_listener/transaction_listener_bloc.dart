import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/transactions/transaction_repository_interface.dart';

part 'transaction_listener_bloc.freezed.dart';
part 'transaction_listener_event.dart';
part 'transaction_listener_state.dart';

/// Bloc for listening to shout-out updates
@injectable
class TransactionListenerBloc
    extends Bloc<TransactionListenerEvent, TransactionListenerState> {
  /// Default constructor
  TransactionListenerBloc(this._repository)
      : super(const TransactionListenerState.initial()) {
    on<TransactionListenerEvent>(
      (event, emit) => event.when(
        listenShoutOutStarted: (shoutOutId) async {
          emit(const TransactionListenerState.loadInProgress());
          await _shoutOutSubscription?.cancel();
          _shoutOutSubscription = _repository
              .watchShoutOutForTransaction(
                shoutOutId,
              )
              .listen(
                (failureOrTransaction) => add(
                  TransactionListenerEvent.shoutOutUpdated(
                    failureOrTransaction,
                  ),
                ),
              );

          return null;
        },
        shoutOutUpdated: (result) => emit(
          result.fold(
            TransactionListenerState.loadFailure,
            TransactionListenerState.loadSuccess,
          ),
        ),
      ),
    );
  }

  final TransactionRepositoryInterface _repository;
  StreamSubscription<Either<Failure, Transaction>>? _shoutOutSubscription;

  @override
  Future<void> close() {
    _shoutOutSubscription?.cancel();
    return super.close();
  }
}
