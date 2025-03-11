import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Email confirmator text field widget
class EmailConfirmatorTextField extends StatelessWidget {
  /// Default constructor
  const EmailConfirmatorTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegistrationFormBloc>();
    return TextFormField(
      onChanged: (value) => bloc.add(
        RegistrationFormEvent.emailConfirmationChanged(value.trim()),
      ),
      validator: (_) => _validator(bloc.state),
      decoration: const InputDecoration(
        labelText: 'Email confirmation',
        prefixIcon: Icon(Icons.email),
        filled: true,
      ),
    );
  }

  String _validator(RegistrationFormState state) =>
      state.emailConfirmator.value.fold(
        (failure) => switch (failure) {
          StringMismatch() => 'Mismatching emails',
          EmptyString() => 'Empty email confirmation',
          _ => 'Unknown error',
        },
        (_) => '',
      );
}
