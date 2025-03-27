import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/views/core/theme/text_styles.dart';

/// Pop-up card for ShoutOut details
class ShoutOutPopupCard extends StatelessWidget {
  /// Default constructor
  const ShoutOutPopupCard({
    required this.shoutOut,
    super.key,
  });

  /// ShoutOut being displayed
  final ShoutOut shoutOut;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        heightFactor: 0.6, // Adjust height as needed
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (shoutOut.imageUrls.isEmpty)
                const Icon(
                  Icons.image_not_supported,
                  size: 80,
                  color: Colors.grey,
                )
              else
                SizedBox(
                  height: 150,
                  child: PageView(
                    children: shoutOut.imageUrls
                        .map(
                          (url) => Image.network(
                            url.getOrCrash(),
                            fit: BoxFit.cover,
                          ),
                        )
                        .toList(),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                shoutOut.title.getOrCrash(),
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                shoutOut.description.getOrCrash(),
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, color: Colors.blue),
                  const SizedBox(width: 5),
                  Text(
                    '${shoutOut.duration.getOrCrash()} min',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BlocConsumer<InterestedShoutOutsActorBloc,
                  InterestedShoutOutsActorState>(
                listener: _listener,
                builder: (context, state) => state is ActionInProgress
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () =>
                            context.read<InterestedShoutOutsActorBloc>().add(
                                  InterestedShoutOutsActorEvent.addToInterested(
                                    shoutOutId: shoutOut.id,
                                  ),
                                ),
                        child: const Text('Add to Interested'),
                      ),
              ),
            ],
          ),
        ),
      );

  void _listener(BuildContext context, InterestedShoutOutsActorState state) {
    if (state is AdditionSuccess) {
      FlushbarHelper.createSuccess(
        duration: const Duration(seconds: 2),
        message: 'Error: Added to interested list!',
      ).show(context);
      context.router.pop();
    } else if (state is AdditionFailure) {
      FlushbarHelper.createError(
        duration: const Duration(seconds: 2),
        message: 'Error: ${state.failure}',
      ).show(context);
    }
  }
}
