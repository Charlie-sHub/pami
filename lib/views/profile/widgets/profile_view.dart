import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/profile/profile_watcher/profile_watcher_bloc.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/profile/widgets/profile_content.dart';

/// Profile view widget
class ProfileView extends StatelessWidget {
  /// Default constructor
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => getIt<ProfileWatcherBloc>()
      ..add(
        const ProfileWatcherEvent.fetchProfile(),
      ),
    child: BlocBuilder<ProfileWatcherBloc, ProfileWatcherState>(
      builder: (context, state) => switch (state) {
        LoadInProgress() => const Center(
          child: CircularProgressIndicator(),
        ),
        LoadSuccess(:final user) => ProfileContent(
          user: user,
        ),
        LoadFailure(:final failure) => Center(
          child: Text(
            'Failed to load profile: $failure',
          ),
        ),
        _ => const SizedBox.shrink(),
      },
    ),
  );
}
