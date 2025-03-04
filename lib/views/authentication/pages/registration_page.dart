import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/user.dart';

/// Registration page for the app
@RoutePage()
class RegistrationPage extends StatelessWidget {
  /// Default constructor
  const RegistrationPage({
    required this.userOption,
    super.key,
  });

  /// The user option, some if there was a successful third party log in
  /// and none if registering directly
  final Option<User> userOption;

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Registration Page'),
        ),
      );
}
