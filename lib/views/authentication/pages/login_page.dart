import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Login page for the app
@RoutePage()
class LoginPage extends StatelessWidget {
  /// Default constructor
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Login Page'),
        ),
      );
}
