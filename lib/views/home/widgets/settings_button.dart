import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pami/views/core/routes/router.gr.dart';

/// Settings button widget
class SettingsButton extends StatelessWidget {
  /// Default constructor
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.settings_rounded,
          size: 25,
          // color: WorldOnColors.accent,
        ),
        onPressed: () => context.router.push(
          const SettingsRoute(),
        ),
      );
}
