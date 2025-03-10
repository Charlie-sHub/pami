import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';

/// Bio text field widget
class BioTextField extends StatelessWidget {
  /// Default constructor
  const BioTextField({
    this.initialValue,
    super.key,
  });

  /// The initial value of the text field
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegistrationFormBloc>();
    return TextFormField(
      maxLength: EntityDescription.maxLength,
      initialValue: initialValue,
      onChanged: (value) => bloc.add(
        RegistrationFormEvent.bioChanged(value.trim()),
      ),
      validator: (_) => _validator(bloc.state),
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: 'Bio',
        prefixIcon: Icon(Icons.text_snippet),
      ),
    );
  }

  String _validator(RegistrationFormState state) => state.user.bio.value.fold(
        (failure) => switch (failure) {
          EmptyString() => 'Empty bio',
          StringExceedsLength() => 'String exceeds length',
          _ => 'Unknown error',
        },
        (_) => '',
      );
}
