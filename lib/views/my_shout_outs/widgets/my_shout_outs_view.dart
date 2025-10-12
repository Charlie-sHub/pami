import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/my_shout_outs/my_shout_outs_watcher/my_shout_outs_watcher_bloc.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/home/widgets/shout_out_card.dart';

/// MyShoutOuts view widget
class MyShoutOutsView extends StatelessWidget {
  /// Default constructor
  const MyShoutOutsView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<MyShoutOutsWatcherBloc>()
      ..add(
        const MyShoutOutsWatcherEvent.watchStarted(),
      ),
    child: SafeArea(
      child: BlocBuilder<MyShoutOutsWatcherBloc, MyShoutOutsWatcherState>(
        builder: (context, state) => switch (state) {
          Initial() || ActionInProgress() => const Center(
            child: CircularProgressIndicator(),
          ),
          LoadSuccess(:final shoutOuts) =>
            shoutOuts.isEmpty
                ? const Center(
                    child: Text('You have not created any shout-outs yet.'),
                  )
                : ListView.builder(
                    itemCount: shoutOuts.length,
                    itemBuilder: (context, index) {
                      final shout = shoutOuts.elementAt(index);
                      return ShoutOutCard(shoutOut: shout);
                    },
                  ),
          LoadFailure(:final failure) => Center(
            child: Text('Error loading your shout-outs: $failure'),
          ),
        },
      ),
    ),
  );
}
