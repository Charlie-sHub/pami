import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';

/// Eula checkbox widget
class EulaCheckbox extends StatelessWidget {
  /// Default constructor
  const EulaCheckbox({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<RegistrationFormBloc, RegistrationFormState>(
        buildWhen: (previous, current) =>
            current.showErrorMessages ||
            previous.acceptedEULA != current.acceptedEULA,
        builder: (context, state) => CheckboxListTile(
          title: const Text('Do you agree with our terms and services?'),
          value: state.acceptedEULA,
          subtitle: !state.acceptedEULA && state.showErrorMessages
              ? const Text(
                  'Please check the EULA',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                )
              : null,
          onChanged: (_) => context.read<RegistrationFormBloc>().add(
                const RegistrationFormEvent.tappedEULA(),
              ),
        ),
      );
}
