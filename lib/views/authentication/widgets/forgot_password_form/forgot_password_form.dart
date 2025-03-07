import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/forgotten_password_form/forgotten_password_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/views/authentication/widgets/email_text_field.dart';

/// Forgot password form widget
class ForgotPasswordForm extends StatelessWidget {
  /// Default constructor
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ForgottenPasswordFormBloc, ForgottenPasswordFormState>(
        buildWhen: _buildWhen,
        builder: (context, state) {
          final bloc = context.read<ForgottenPasswordFormBloc>();
          return SingleChildScrollView(
            key: const Key('singleChildScrollView'),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 200,
            ),
            child: Form(
              autovalidateMode: state.showErrorMessages
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EmailTextField(
                    validator: (_) => _emailValidator(state),
                    eventToAdd: (String value) => bloc.add(
                      ForgottenPasswordFormEvent.emailChanged(value),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      bloc.add(
                        const ForgottenPasswordFormEvent.submitted(),
                      );
                    },
                    child: const Text('Reset Password'),
                  ),
                ],
              ),
            ),
          );
        },
      );

  bool _buildWhen(_, ForgottenPasswordFormState current) =>
      current.showErrorMessages ||
      current.email.isValid() ||
      !current.email.isValid();

  String _emailValidator(ForgottenPasswordFormState state) =>
      state.email.value.fold(
        (failure) => switch (failure) {
          InvalidEmail() => 'Invalid email',
          _ => 'Unknown error',
        },
        (_) => '',
      );
}
