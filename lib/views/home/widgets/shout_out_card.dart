import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/application/shout_out_management/shout_out_deletion_actor/shout_out_deletion_actor_bloc.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/views/home/widgets/shout_out_header_image.dart';
import 'package:pami/views/interested_shout_outs/widgets/creator_actions_row.dart';
import 'package:pami/views/my_shout_outs/widgets/qr_expandable.dart';

/// One card item, composes header/body/footer.
class ShoutOutCard extends StatelessWidget {
  /// Default constructor
  const ShoutOutCard({
    required this.shoutOut,
    super.key,
  });

  /// ShoutOut to display
  final ShoutOut shoutOut;

  @override
  Widget build(BuildContext context) {
    final isInterested = shoutOut.creatorUser.isSome();
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShoutOutHeaderImage(
            imageUrls: shoutOut.imageUrls.toList(),
            onDismiss: () => isInterested
                ? context.read<InterestedShoutOutsActorBloc>().add(
                    InterestedShoutOutsActorEvent.addToInterested(
                      shoutOutId: shoutOut.id,
                    ),
                  )
                : context.read<ShoutOutDeletionActorBloc>().add(
                    ShoutOutDeletionActorEvent.deleteRequested(
                      shoutOutId: shoutOut.id,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shoutOut.title.getOrCrash(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  shoutOut.description.getOrCrash(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                if (isInterested)
                  CreatorActionsRow(shoutOut: shoutOut)
                else
                  QrExpandable(id: shoutOut.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
