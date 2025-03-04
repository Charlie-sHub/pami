import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/views/authentication/widgets/email_text_field.dart';
import 'package:pami/views/authentication/widgets/login_form/login_apple_button.dart';
import 'package:pami/views/authentication/widgets/login_form/login_button.dart';
import 'package:pami/views/authentication/widgets/login_form/login_google_button.dart';
import 'package:pami/views/authentication/widgets/login_form/login_trouble_button.dart';
import 'package:pami/views/authentication/widgets/login_form/register_button.dart';
import 'package:pami/views/authentication/widgets/password_text_field.dart';
import 'package:pami/views/core/theme/text_styles.dart';

/// Login form widget.
class LoginForm extends StatelessWidget {
  /// Default constructor.
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'PAMI',
                style: AppTextStyles.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Form(
                autovalidateMode:
                    context.read<LoginFormBloc>().state.showErrorMessages
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    EmailTextField(
                      validator: (_) => _emailValidator(context),
                      eventToAdd: (String value) =>
                          context.read<LoginFormBloc>().add(
                                LoginFormEvent.emailChanged(value),
                              ),
                    ),
                    const SizedBox(height: 15),
                    PasswordTextField(
                      eventToAdd: (String value) =>
                          context.read<LoginFormBloc>().add(
                                LoginFormEvent.passwordChanged(value),
                              ),
                      validator: (_) => _passwordValidator(context),
                    ),
                    const SizedBox(height: 10),
                    const LoginButton(),
                    const LoginTroubleButton(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LoginGoogleButton(),
                  LoginAppleButton(),
                ],
              ),
              const SizedBox(height: 60),
              const RegisterButton(),
            ],
          ),
        ),
      );

  String _passwordValidator(BuildContext context) {
    final passwordValue = context.read<LoginFormBloc>().state.password.value;
    return passwordValue.fold(
      (failure) => switch (failure) {
        EmptyString() => 'Empty password',
        MultiLineString() => 'Passwords cannot be multiline',
        StringExceedsLength() => 'Password exceeds length',
        InvalidPassword() => 'Invalid password',
        _ => 'Unknown error',
      },
      (_) => '',
    );
  }

  String _emailValidator(BuildContext context) {
    final emailValue = context.read<LoginFormBloc>().state.email.value;
    return emailValue.fold(
      (failure) => switch (failure) {
        InvalidEmail() => 'Invalid email',
        _ => 'Unknown error',
      },
      (_) => '',
    );
  }
}
