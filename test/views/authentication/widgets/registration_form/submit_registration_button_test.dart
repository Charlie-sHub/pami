import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';

/// Submit registration button widget
class SubmitRegistrationButton extends StatelessWidget {
  /// Default constructor
  const SubmitRegistrationButton({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<RegistrationFormBloc, RegistrationFormState>(
        buildWhen: _buildWhen,
        builder: (context, state) => state.isSubmitting
            ? const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              )
            : ElevatedButton(
                onPressed: () => context.read<RegistrationFormBloc>().add(
                      const RegistrationFormEvent.submitted(),
                    ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
      );

  bool _buildWhen(
    RegistrationFormState previous,
    RegistrationFormState current,
  ) =>
      previous.isSubmitting != current.isSubmitting;
}
