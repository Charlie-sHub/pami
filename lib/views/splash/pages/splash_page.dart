import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// The Splash Page widget
/// Checks for authentication and routes the user to either
/// the HomePage or the LoginPage
@RoutePage()
class SplashPage extends StatelessWidget {
  /// Default constructor
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
}
