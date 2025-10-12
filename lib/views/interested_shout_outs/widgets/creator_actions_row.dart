import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/views/interested_shout_outs/widgets/button_column.dart';
import 'package:pami/views/interested_shout_outs/widgets/user_avatar.dart';

/// Extracted lower section used in Interested Shout-Outs list:
/// shows creator info (avatar, name, username) and the action buttons.
class CreatorActionsRow extends StatelessWidget {
  /// Default constructor
  const CreatorActionsRow({required this.shoutOut, super.key});

  /// ShoutOut to display its creator
  final ShoutOut shoutOut;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      shoutOut.creatorUser.fold(
        () => const SizedBox.shrink(),
        (user) => Column(
          children: [
            UserAvatar(
              user: user,
              size: 80,
            ),
            const SizedBox(height: 4),
            Text(
              user.name.getOrCrash(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              user.username.getOrCrash(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: 16),
      ButtonColumn(shoutOut: shoutOut),
    ],
  );
}
