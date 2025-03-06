import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';

/// Log in with Apple button.
class LoginAppleButton extends StatelessWidget {
  /// Default constructor.
  const LoginAppleButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const FaIcon(FontAwesomeIcons.apple),
        onPressed: () => context.read<LoginFormBloc>().add(
              const LoginFormEvent.loggedInApple(),
            ),
      );
}
