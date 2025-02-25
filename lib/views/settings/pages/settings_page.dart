import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Settings page for the app
@RoutePage()
class SettingsPage extends StatelessWidget {
  /// Default constructor
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Settings Page'),
        ),
      );
}
