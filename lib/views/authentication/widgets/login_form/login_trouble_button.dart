import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pami/views/core/routes/router.gr.dart';
import 'package:pami/views/core/theme/colors.dart';

/// Log in trouble button.
class LoginTroubleButton extends StatelessWidget {
  /// Default constructor.
  const LoginTroubleButton({super.key});

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () => context.router.push(
          const ForgotPasswordRoute(),
        ),
        child: const Text(
          'Did you forget your password?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      );
}
