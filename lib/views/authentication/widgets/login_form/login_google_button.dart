import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';

/// Log in with Google button.
class LoginGoogleButton extends StatelessWidget {
  /// Default constructor.
  const LoginGoogleButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const FaIcon(FontAwesomeIcons.google),
        onPressed: () => context.read<LoginFormBloc>().add(
              const LoginFormEvent.loggedInGoogle(),
            ),
      );
}
