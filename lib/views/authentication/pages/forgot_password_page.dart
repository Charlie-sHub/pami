import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Forgot password page for the app
@RoutePage()
class ForgotPasswordPage extends StatelessWidget {
  /// Default constructor
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Forgot Password Page'),
        ),
      );
}
