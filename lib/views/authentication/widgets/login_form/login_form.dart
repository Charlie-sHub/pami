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
  Widget build(BuildContext context) =>
      BlocBuilder<LoginFormBloc, LoginFormState>(
        buildWhen: _buildWhen,
        builder: (context, state) {
          final bloc = context.read<LoginFormBloc>();
          return SingleChildScrollView(
            key: const Key('singleChildScrollView'),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 200,
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
                  autovalidateMode: state.showErrorMessages
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      EmailTextField(
                        key: const Key('emailField'),
                        validator: (_) => _emailValidator(state),
                        eventToAdd: (String value) => bloc.add(
                          LoginFormEvent.emailChanged(value),
                        ),
                      ),
                      const SizedBox(height: 15),
                      PasswordTextField(
                        key: const Key('passwordField'),
                        eventToAdd: (String value) => bloc.add(
                          LoginFormEvent.passwordChanged(value),
                        ),
                        validator: (_) => _passwordValidator(state),
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
          );
        },
      );

  bool _buildWhen(LoginFormState previous, LoginFormState current) =>
      previous.showErrorMessages != current.showErrorMessages;

  String _passwordValidator(LoginFormState state) {
    final passwordValue = state.password.value;
    return passwordValue.fold(
      (failure) => switch (failure) {
        EmptyString() => 'Empty password',
        _ => 'Unknown error',
      },
      (_) => '',
    );
  }

  String _emailValidator(LoginFormState state) {
    final emailValue = state.email.value;
    return emailValue.fold(
      (failure) => switch (failure) {
        InvalidEmail() => 'Invalid email',
        _ => 'Unknown error',
      },
      (_) => '',
    );
  }
}
