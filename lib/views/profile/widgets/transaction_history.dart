import 'package:flutter/material.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Transaction History of the profile
class TransactionHistory extends StatelessWidget {
  /// Default constructor
  const TransactionHistory({required this.userId, super.key});

  /// User id of the profile
  final UniqueId userId;

  @override
  Widget build(BuildContext context) => Container(
    height: 220,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Center(
      child: Text('No transactions yet.'),
    ),
  );
}
