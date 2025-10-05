import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Pop-up card's button row
class ShoutOutModalButtonRow extends StatelessWidget {
  /// Default constructor
  const ShoutOutModalButtonRow({
    required this.shoutOutId,
    super.key,
  });

  /// The given ShoutOut's id
  final UniqueId shoutOutId;

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<InterestedShoutOutsActorBloc, InterestedShoutOutsActorState>(
        listener: _listener,
        builder: (context, state) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => context.router.pop(),
              child: const Text('Not Interested'),
            ),
            if (state is ActionInProgress)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () =>
                    context.read<InterestedShoutOutsActorBloc>().add(
                      InterestedShoutOutsActorEvent.addToInterested(
                        shoutOutId: shoutOutId,
                      ),
                    ),
                child: const Text('Add to Interested'),
              ),
          ],
        ),
      );

  Future<void> _listener(
    BuildContext context,
    InterestedShoutOutsActorState state,
  ) async {
    if (state is AdditionSuccess) {
      context.router.pop();
    } else if (state is AdditionFailure) {
      await FlushbarHelper.createError(
        duration: const Duration(seconds: 2),
        message: 'Error: ${state.failure}',
      ).show(context);
    }
  }
}
