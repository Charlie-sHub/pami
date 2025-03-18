import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/home/home_navigation_actor/home_navigation_actor_bloc.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/home/widgets/create_shout_out_floating_button.dart';
import 'package:pami/views/home/widgets/pami_app_bar.dart';
import 'package:pami/views/home/widgets/pami_bottom_navigation_bar.dart';
import 'package:pami/views/interested_shout_outs/widgets/interested_shout_outs_view.dart';
import 'package:pami/views/map/widgets/map_view.dart';
import 'package:pami/views/my_shout_outs/widgets/my_shout_outs_view.dart';
import 'package:pami/views/notifications/widgets/notifications_view.dart';
import 'package:pami/views/profile/widgets/profile_view.dart';

/// Home page for the app
@RoutePage()
class HomePage extends StatelessWidget {
  /// Default constructor
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => getIt<HomeNavigationActorBloc>(),
        child: BlocBuilder<HomeNavigationActorBloc, HomeNavigationActorState>(
          builder: (context, state) => Scaffold(
            appBar: const PamiAppBar(),
            extendBody: true,
            body: IndexedStack(
              index: state.currentIndex,
              children: const [
                MapView(),
                InterestedShoutOutsView(),
                MyShoutOutsView(),
                ProfileView(),
                NotificationsView(),
              ],
            ),
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: const CreateShoutOutFloatingButton(),
            bottomNavigationBar: PamiBottomNavigationBar(
              index: state.currentIndex,
            ),
          ),
        ),
      );
}
