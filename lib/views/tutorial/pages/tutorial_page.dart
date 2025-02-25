import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Tutorial page for the app
@RoutePage()
class TutorialPage extends StatelessWidget {
  /// Default constructor
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Tutorial Page'),
        ),
      );
}
