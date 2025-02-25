import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Home page for the app
@RoutePage()
class HomePage extends StatelessWidget {
  /// Default constructor
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Home Page'),
        ),
      );
}
