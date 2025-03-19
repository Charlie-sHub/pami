import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/home/home_navigation_actor/home_navigation_actor_bloc.dart';
import 'package:pami/views/core/theme/colors.dart';

/// Bottom navigation bar widget
class PamiBottomNavigationBar extends StatelessWidget {
  /// Default constructor
  const PamiBottomNavigationBar({
    required this.index,
    super.key,
  });

  /// Bottom navigation bar index
  final int index;

  @override
  Widget build(BuildContext context) => AnimatedBottomNavigationBar(
        scaleFactor: 0,
        notchSmoothness: NotchSmoothness.defaultEdge,
        notchMargin: 5,
        iconSize: 28,
        backgroundColor: AppColors.background,
        onTap: (index) => context.read<HomeNavigationActorBloc>().add(
              HomeNavigationActorEvent.tabSelected(index),
            ),
        gapLocation: GapLocation.center,
        activeIndex: index,
        activeColor: AppColors.primary,
        inactiveColor: AppColors.secondary,
        leftCornerRadius: 12,
        rightCornerRadius: 12,
        icons: const [
          Icons.explore_rounded,
          Icons.flag_rounded,
          Icons.bookmark_rounded,
          Icons.person_rounded,
        ],
      );
}
