import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/name.dart';

/// Username text field widget
class UsernameTextField extends StatelessWidget {
  /// Default constructor
  const UsernameTextField({
    this.initialValue,
    super.key,
  });

  /// The initial value of the text field
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegistrationFormBloc>();
    return TextFormField(
      maxLength: Name.maxLength,
      initialValue: initialValue,
      onChanged: (value) =>
          bloc.add(
            RegistrationFormEvent.usernameChanged(value.trim()),
          ),
      validator: (_) => _validator(bloc.state),
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: 'Username',
        prefixIcon: Icon(Icons.account_box),
      ),
    );
  }

  String _validator(RegistrationFormState state) =>
      state.user.username.value.fold(
            (failure) =>
        switch (failure) {
          EmptyString() => 'Empty username',
          MultiLineString() => 'Multi-line string',
          StringExceedsLength() => 'String exceeds length',
          InvalidName() => 'Invalid username',
          _ => 'Unknown error',
        },
            (_) => '',
      );
}
