import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/views/core/theme/colors.dart';
import 'package:pami/views/core/theme/text_styles.dart';
import 'package:pami/views/map/widgets/shout_out_modal_button_row.dart';
import 'package:pami/views/map/widgets/shout_out_modal_image_slider.dart';

/// Pop-up card for ShoutOut details
class ShoutOutModal extends StatelessWidget {
  /// Default constructor
  const ShoutOutModal({
    required this.shoutOut,
    super.key,
  });

  /// ShoutOut being displayed
  final ShoutOut shoutOut;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShoutOutModalImageSlider(imageUrls: shoutOut.imageUrls),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    shoutOut.title.getOrCrash(),
                    style: AppTextStyles.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Text(
                      '${shoutOut.duration.getOrCrash().toInt()} min',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              shoutOut.description.getOrCrash(),
              style: AppTextStyles.bodyMedium,
            ),
            const Spacer(),
            ShoutOutModalButtonRow(shoutOutId: shoutOut.id),
          ],
        ),
      );
}
