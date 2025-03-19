import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/home/home_navigation_actor/home_navigation_actor_bloc.dart';
import 'package:pami/views/home/misc/navigation_indexes.dart';
import 'package:pami/views/home/widgets/notifications_button.dart';
import 'package:pami/views/home/widgets/settings_button.dart';

/// App bar widget
class PamiAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Default constructor
  const PamiAppBar({super.key});

  @override
  Widget build(BuildContext context) => AppBar(
        automaticallyImplyLeading: false,
        title: BlocBuilder<HomeNavigationActorBloc, HomeNavigationActorState>(
          builder: (context, state) => Text(
            _getTitleForIndex(state.currentIndex),
          ),
        ),
        actions: const [
          NotificationsButton(),
          SettingsButton(),
        ],
        elevation: 0,
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight - 15);

  String _getTitleForIndex(int index) {
    String title;
    switch (index) {
      case NavigationIndexes.mapView:
        title = 'Map';
      case NavigationIndexes.interestedShoutOutsView:
        title = 'Interests';
      case NavigationIndexes.myShoutOutsView:
        title = 'My Shout Outs';
      case NavigationIndexes.profileView:
        title = 'Profile';
      case NavigationIndexes.notificationsView:
        title = 'Notifications';
      default:
        title = 'Unknown View';
    }
    return title;
  }
}
