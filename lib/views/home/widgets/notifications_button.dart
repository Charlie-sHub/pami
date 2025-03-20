import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/home/home_navigation_actor/home_navigation_actor_bloc.dart';
import 'package:pami/application/notifications/notifications_watcher/notifications_watcher_bloc.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/core/theme/colors.dart';
import 'package:pami/views/home/misc/navigation_indexes.dart';

/// Notifications button widget
class NotificationsButton extends StatelessWidget {
  /// Default constructor
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => getIt<NotificationsWatcherBloc>()
          ..add(const NotificationsWatcherEvent.watchStarted()),
        child: BlocBuilder<NotificationsWatcherBloc, NotificationsWatcherState>(
          builder: (context, state) => IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              _getIconData(state),
              color: _getIconColor(state),
              size: 25,
            ),
            onPressed: () => context.read<HomeNavigationActorBloc>().add(
                  const HomeNavigationActorEvent.tabSelected(
                    NavigationIndexes.notificationsView,
                  ),
                ),
          ),
        ),
      );

  IconData _getIconData(NotificationsWatcherState state) {
    switch (state) {
      case LoadSuccess(:final notifications):
        return notifications.isNotEmpty
            ? Icons.notifications_on_rounded
            : Icons.notifications;
      case Initial():
      case LoadInProgress():
      case LoadFailure():
        return Icons.notifications;
    }
  }

  Color? _getIconColor(NotificationsWatcherState state) {
    switch (state) {
      case LoadSuccess(:final notifications):
        return notifications.isNotEmpty ? AppColors.background : null;
      case Initial():
      case LoadInProgress():
      case LoadFailure():
        return null;
    }
  }
}
