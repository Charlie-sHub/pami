import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Profile management page for the app
@RoutePage()
class HelpAndSupportPage extends StatelessWidget {
  /// Default constructor
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Help and Support Page'),
        ),
      );
}
