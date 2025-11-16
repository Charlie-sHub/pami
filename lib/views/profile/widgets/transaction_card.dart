import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/views/core/theme/text_styles.dart';
import 'package:pami/views/profile/widgets/outcome_icon.dart';

/// Card widget representing a [Transaction]
class TransactionCard extends StatelessWidget {
  /// Default constructor
  const TransactionCard({
    required this.transaction,
    super.key,
  });

  /// The [Transaction] to display
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final title = transaction.shoutOutTitle.value.fold(
      (_) => '',
      (value) => value,
    );

    final dateTime = transaction.dateCreated.value.fold<DateTime?>(
      (_) => null,
      (value) => value,
    );

    final isPositive = transaction.isPositiveForCreator.fold<bool?>(
      () => null,
      (value) => value,
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(
              _typeEmoji(transaction.shoutOutType),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      dateTime.toString(),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            OutcomeIcon(isPositive: isPositive),
          ],
        ),
      ),
    );
  }
}

String _typeEmoji(ShoutOutType type) {
  switch (type) {
    case ShoutOutType.offer:
      return '🤝';
    case ShoutOutType.request:
      return '🙋‍♂️';
  }
}
