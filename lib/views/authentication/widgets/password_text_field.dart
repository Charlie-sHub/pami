import 'package:flutter/material.dart';
import 'package:pami/domain/core/validation/objects/password.dart';
import 'package:pami/views/core/misc/event_to_add_typedef.dart';
import 'package:pami/views/core/misc/validator_typedef.dart';

/// TextField for password
class PasswordTextField extends StatelessWidget {
  /// Default constructor
  const PasswordTextField({
    required this.eventToAdd,
    required this.validator,
    super.key,
  });

  /// Event to add password
  final EventToAdd eventToAdd;

  /// Validator
  final Validator<String?> validator;

  @override
  Widget build(BuildContext context) => TextFormField(
        maxLength: Password.maxLength,
        autocorrect: false,
        obscureText: true,
        onChanged: (value) => eventToAdd(value.trim()),
        validator: validator,
        decoration: const InputDecoration(
          labelText: 'Password',
          counterText: '',
          prefixIcon: Icon(
            Icons.lock,
          ),
          filled: true,
        ),
      );
}
