import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Password confirmator text field widget
class PasswordConfirmatorTextField extends StatelessWidget {
  /// Default constructor
  const PasswordConfirmatorTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegistrationFormBloc>();
    return TextFormField(
      onChanged: (value) => bloc.add(
        RegistrationFormEvent.passwordConfirmationChanged(value.trim()),
      ),
      validator: (_) => _validator(bloc.state),
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password confirmation',
        prefixIcon: Icon(Icons.lock),
        filled: true,
      ),
    );
  }

  String _validator(RegistrationFormState state) =>
      state.passwordConfirmator.value.fold(
        (failure) => switch (failure) {
          StringMismatch() => 'Mismatching passwords',
          EmptyString() => 'Empty password confirmation',
          _ => 'Unknown error',
        },
        (_) => '',
      );
}
