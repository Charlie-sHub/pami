import 'package:flutter/material.dart';
import 'package:pami/views/core/misc/event_to_add_typedef.dart';
import 'package:pami/views/core/misc/validator_typedef.dart';

/// A text field for email addresses.
class EmailTextField extends StatelessWidget {
  /// Default constructor
  const EmailTextField({
    required this.eventToAdd,
    required this.validator,
    this.initialValue,
    super.key,
  });

  /// The event to add on changes.
  final EventToAdd eventToAdd;

  /// The validator to use.
  final Validator<String?> validator;

  /// The initial value.
  final String? initialValue;

  @override
  Widget build(BuildContext context) => TextFormField(
        onChanged: (value) => eventToAdd(value.trim()),
        initialValue: initialValue,
        validator: validator,
        autocorrect: false,
        decoration: const InputDecoration(
          labelText: 'Email Address',
          prefixIcon: Icon(
            Icons.email
          ),
          filled: true,
        ),
      );
}
