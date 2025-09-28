import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/views/interested_shout_outs/widgets/pill_button.dart';
import 'package:pami/views/interested_shout_outs/widgets/shout_out_header_image.dart';
import 'package:pami/views/interested_shout_outs/widgets/user_avatar.dart';

/// One card item, composes header/body/footer.
class InterestedShoutOutCard extends StatelessWidget {
  /// Default constructor
  const InterestedShoutOutCard({required this.shoutOut, super.key});

  /// ShoutOut to display
  final ShoutOut shoutOut;

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShoutOutHeaderImage(
          title: shoutOut.title.getOrCrash(),
          imageUrls: shoutOut.imageUrls.toList(),
          onDismiss: () {
            // TODO: dispatch UnmarkInterest action
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shoutOut.description.getOrCrash(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  UserAvatar(
                    userOption: shoutOut.creatorUser,
                    size: 80,
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PillButton(
                        label: 'Chat',
                        onPressed: () {
                          // TODO: implement chat logic
                        },
                      ),
                      const SizedBox(height: 8),
                      PillButton(
                        label: 'Scan',
                        onPressed: () {
                          // TODO: implement scan logic
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
