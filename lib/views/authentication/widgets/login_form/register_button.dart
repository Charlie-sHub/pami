import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pami/views/core/routes/router.gr.dart';
import 'package:pami/views/core/theme/colors.dart';

/// Register Button
class RegisterButton extends StatelessWidget {
  /// Default constructor
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => context.router.push(
          RegistrationRoute(userOption: none()),
        ),
        child: const Text(
          'Register',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
}
