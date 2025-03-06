import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';

/// Log in button
class LoginButton extends StatelessWidget {
  /// Default constructor
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => context.read<LoginFormBloc>().add(
              const LoginFormEvent.loggedIn(),
            ),
        child: const Text(
          'Log In',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
}
