import 'package:flutter/material.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/views/core/theme/colors.dart';

/// Error card widget
class ErrorCard extends StatelessWidget {
  /// Default constructor
  const ErrorCard({
    required this.failure,
    super.key,
  });

  /// The failure to display
  final Failure failure;

  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.onError,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Error loading shout-outs: ${failure.message}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
}
