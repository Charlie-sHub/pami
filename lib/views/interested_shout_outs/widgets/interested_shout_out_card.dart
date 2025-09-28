import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
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
          imageUrls: shoutOut.imageUrls.toList(),
          onDismiss: () {
            // TODO: dispatch UnmarkInterest action
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
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
              Row(
                children: [
                  shoutOut.creatorUser.fold(
                    () => const SizedBox.shrink(),
                    (user) => Column(
                      children: [
                        UserAvatar(
                          userOption: shoutOut.creatorUser,
                          size: 80,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.name.getOrCrash(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          user.username.getOrCrash(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.black.withAlpha(150),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            // TODO: implement chat logic
                          },
                          child: const Text('Go to chat'),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {
                            // TODO: implement scan logic
                          },
                          child: const Text('Scan QR'),
                        ),
                      ],
                    ),
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
