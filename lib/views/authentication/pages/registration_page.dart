import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Registration page for the app
@RoutePage()
class RegistrationPage extends StatelessWidget {
  /// Default constructor
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Registration Page'),
        ),
      );
}
