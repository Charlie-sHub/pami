import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/transactions/transaction_repository_interface.dart';

part 'transaction_history_watcher_bloc.freezed.dart';

part 'transaction_history_watcher_event.dart';

part 'transaction_history_watcher_state.dart';

/// Transaction history watcher bloc
@injectable
class TransactionHistoryWatcherBloc
    extends
        Bloc<TransactionHistoryWatcherEvent, TransactionHistoryWatcherState> {
  /// Default constructor
  TransactionHistoryWatcherBloc(this._repository)
    : super(const TransactionHistoryWatcherState.initial()) {
    on<_FetchTransactionHistory>(_onFetchTransactionHistory);
  }

  final TransactionRepositoryInterface _repository;

  Future<void> _onFetchTransactionHistory(
    _FetchTransactionHistory event,
    Emitter<TransactionHistoryWatcherState> emit,
  ) async {
    emit(const TransactionHistoryWatcherState.loadInProgress());
    final result = await _repository.fetchUserTransactions(event.userId);
    emit(
      result.fold(
        TransactionHistoryWatcherState.loadFailure,
        TransactionHistoryWatcherState.loadSuccess,
      ),
    );
  }
}
