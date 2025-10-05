import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/application/transactions/karma_vote_actor/karma_vote_actor_bloc.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/views/core/routes/router.gr.dart';

/// Column of buttons, first to go to chat or scan QR
/// but if the scan is successful it will show voting buttons
class ButtonColumn extends StatelessWidget {
  /// Default constructor
  const ButtonColumn({
    required this.shoutOut,
    super.key,
  });

  /// ShoutOut
  final ShoutOut shoutOut;

  @override
  Widget build(BuildContext context) => Expanded(
    child:
        BlocBuilder<
          InterestedShoutOutsActorBloc,
          InterestedShoutOutsActorState
        >(
          builder: (context, state) {
            if (state is ScanSuccess) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => context.read<KarmaVoteActorBloc>().add(
                      KarmaVoteActorEvent.voteSubmitted(
                        shoutOutId: shoutOut.id,
                        isPositive: true,
                      ),
                    ),
                    icon: const Icon(
                      Icons.thumb_up_alt_rounded,
                      size: 50,
                    ),
                    color: Colors.green,
                  ),
                  IconButton(
                    onPressed: () => context.read<KarmaVoteActorBloc>().add(
                      KarmaVoteActorEvent.voteSubmitted(
                        shoutOutId: shoutOut.id,
                        isPositive: false,
                      ),
                    ),
                    icon: const Icon(
                      Icons.thumb_down_alt_rounded,
                      size: 50,
                    ),
                    color: Colors.red,
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () => context.router.push(
                      ConversationRoute(shoutOut: shoutOut),
                    ),
                    child: const Text('Go to chat'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () async {
                      final result = await context.router.push<String>(
                        const ScanRoute(),
                      );
                      if (result != null) {
                        if (context.mounted) {
                          context.read<InterestedShoutOutsActorBloc>().add(
                            InterestedShoutOutsActorEvent.scanCompleted(
                              shoutOutId: shoutOut.id,
                              payload: result,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Scan QR'),
                  ),
                ],
              );
            }
          },
        ),
  );
}
