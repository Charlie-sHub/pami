import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Shout Out creation page for the app
@RoutePage()
class ShoutOutCreationPage extends StatelessWidget {
  /// Default constructor
  const ShoutOutCreationPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Shout-Out Creation Page'),
        ),
      );
}
