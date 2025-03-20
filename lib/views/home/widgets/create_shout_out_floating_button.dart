import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pami/views/core/routes/router.gr.dart';
import 'package:pami/views/core/theme/colors.dart';

/// Floating button widget
class CreateShoutOutFloatingButton extends StatelessWidget {
  /// Default constructor
  const CreateShoutOutFloatingButton({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 40,
        width: 40,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColors.primary,
          onPressed: () => context.router.push(
            const ShoutOutCreationRoute(),
          ),
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: AppColors.onPrimary,
            size: 32,
          ),
        ),
      );
}
