import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Profile management page for the app
@RoutePage()
class ProfileManagementPage extends StatelessWidget {
  /// Default constructor
  const ProfileManagementPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Profile Management Page'),
        ),
      );
}
