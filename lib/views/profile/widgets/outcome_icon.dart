import 'package:flutter/material.dart';

/// Icon that represents the outcome of a Transaction
class OutcomeIcon extends StatelessWidget {
  /// Default constructor
  const OutcomeIcon({
    required this.isPositive,
    super.key,
  });

  /// Whether the transaction was positive or negative
  final bool? isPositive;

  @override
  Widget build(BuildContext context) {
    if (isPositive ?? false) {
      return const Icon(
        Icons.thumb_up,
        color: Colors.green,
      );
    } else if (isPositive == false) {
      return const Icon(
        Icons.thumb_down,
        color: Colors.red,
      );
    } else {
      return const Icon(
        Icons.remove,
        color: Colors.grey,
      );
    }
  }
}
