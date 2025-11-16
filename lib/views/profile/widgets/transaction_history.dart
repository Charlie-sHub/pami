import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/transactions/transaction_history_watcher/transaction_history_watcher_bloc.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/profile/widgets/transaction_card.dart';

/// Transaction History of the profile
class TransactionHistory extends StatelessWidget {
  /// Default constructor
  const TransactionHistory({required this.userId, super.key});

  /// User id of the profile
  final UniqueId userId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) =>
        getIt<TransactionHistoryWatcherBloc>()
          ..add(TransactionHistoryWatcherEvent.fetchTransactionHistory(userId)),
    child:
        BlocBuilder<
          TransactionHistoryWatcherBloc,
          TransactionHistoryWatcherState
        >(
          builder: (context, state) => Container(
            height: 220,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: switch (state) {
              Initial() => const Center(
                child: Text('No transactions yet.'),
              ),
              LoadInProgress() => const Center(
                child: CircularProgressIndicator(),
              ),
              LoadSuccess(:final transactions) =>
                transactions.isEmpty
                    ? const Center(child: Text('No transactions yet.'))
                    : ListView.separated(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) => TransactionCard(
                          transaction: transactions[index],
                        ),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 2,
                        ),
                      ),
              LoadFailure(:final failure) => Center(
                child: Text(
                  'Failed to load transactions: $failure',
                ),
              ),
            },
          ),
        ),
  );
}
