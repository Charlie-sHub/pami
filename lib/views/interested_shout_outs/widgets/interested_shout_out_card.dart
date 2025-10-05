import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/application/transactions/karma_vote_actor/karma_vote_actor_bloc.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/interested_shout_outs/widgets/button_column.dart';
import 'package:pami/views/interested_shout_outs/widgets/shout_out_header_image.dart';
import 'package:pami/views/interested_shout_outs/widgets/user_avatar.dart';

/// One card item, composes header/body/footer.
class InterestedShoutOutCard extends StatelessWidget {
  /// Default constructor
  const InterestedShoutOutCard({required this.shoutOut, super.key});

  /// ShoutOut to display
  final ShoutOut shoutOut;

  @override
  Widget build(
    BuildContext context,
  ) => MultiBlocProvider(
    providers: [
      BlocProvider<InterestedShoutOutsActorBloc>(
        create: (context) => getIt<InterestedShoutOutsActorBloc>(),
      ),
      BlocProvider(
        create: (context) => getIt<KarmaVoteActorBloc>(),
      ),
    ],
    child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShoutOutHeaderImage(
            imageUrls: shoutOut.imageUrls.toList(),
            id: shoutOut.id,
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
                          shoutOut.creatorUser.fold(
                            () => const SizedBox.shrink(),
                            (user) => UserAvatar(
                              user: user,
                              size: 80,
                            ),
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
                    ButtonColumn(shoutOut: shoutOut),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
