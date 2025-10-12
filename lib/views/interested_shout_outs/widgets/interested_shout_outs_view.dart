import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart'
    hide ActionInProgress, Initial;
import 'package:pami/application/interested_shout_outs/interested_shout_outs_watcher/interested_shout_outs_watcher_bloc.dart';
import 'package:pami/application/transactions/karma_vote_actor/karma_vote_actor_bloc.dart'
    hide Initial;
import 'package:pami/injection.dart';
import 'package:pami/views/home/widgets/shout_out_card.dart';

/// InterestedShoutOuts view widget
class InterestedShoutOutsView extends StatelessWidget {
  /// Default constructor
  const InterestedShoutOutsView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<InterestedShoutOutsWatcherBloc>()
      ..add(
        const InterestedShoutOutsWatcherEvent.watchStarted(),
      ),
    child: MultiBlocProvider(
      providers: [
        BlocProvider<InterestedShoutOutsActorBloc>(
          create: (context) => getIt<InterestedShoutOutsActorBloc>(),
        ),
        BlocProvider<KarmaVoteActorBloc>(
          create: (context) => getIt<KarmaVoteActorBloc>(),
        ),
      ],
      child: SafeArea(
        child:
            BlocBuilder<
              InterestedShoutOutsWatcherBloc,
              InterestedShoutOutsWatcherState
            >(
              builder: (context, state) => switch (state) {
                Initial() || ActionInProgress() => const Center(
                  child: CircularProgressIndicator(),
                ),
                LoadSuccess(:final shoutOuts) =>
                  shoutOuts.isEmpty
                      ? const Center(
                          child: Text('No interested shout-outs yet.'),
                        )
                      : ListView.builder(
                          itemCount: shoutOuts.length,
                          itemBuilder: (context, index) {
                            final shout = shoutOuts.elementAt(index);
                            return ShoutOutCard(shoutOut: shout);
                          },
                        ),
                LoadFailure(:final failure) => Center(
                  child: Text('Error loading shout-outs: $failure'),
                ),
              },
            ),
      ),
    ),
  );
}
