import 'package:flutter/material.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/views/core/theme/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Expandable lower section used in "My Shout-Outs" list:
/// Displays a QR code for the shout-out id using a built-in ExpansionTile.
class QrExpandable extends StatelessWidget {
  /// Default constructor
  const QrExpandable({required this.id, super.key});

  /// ID to create QR code
  final UniqueId id;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text('QR code', style: textTheme.bodyMedium),
        childrenPadding: const EdgeInsets.only(top: 12),
        children: [
          Center(
            child: Column(
              children: [
                QrImageView(
                  data: id.getOrCrash(),
                  size: 180,
                  eyeStyle: const QrEyeStyle(
                    color: AppColors.primary,
                    eyeShape: QrEyeShape.circle,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    color: AppColors.primary,
                    dataModuleShape: QrDataModuleShape.circle,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  id.getOrCrash(),
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.black.withAlpha(140),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
