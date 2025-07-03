import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/authentication/authentication_bloc.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/authentication/widgets/registration_form/registration_form.dart';
import 'package:pami/views/core/routes/router.gr.dart';

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
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: BlocProvider(
        create: (_) => getIt<RegistrationFormBloc>()
          ..add(
            RegistrationFormEvent.initialized(userOption),
          ),
        child: BlocListener<RegistrationFormBloc, RegistrationFormState>(
          listenWhen: _listenWhen,
          listener: _listener,
          child: RegistrationForm(userOption: userOption),
        ),
      ),
    ),
  );

  bool _listenWhen(
    RegistrationFormState previous,
    RegistrationFormState current,
  ) => previous.failureOrSuccessOption != current.failureOrSuccessOption;

  void _listener(BuildContext context, RegistrationFormState state) =>
      state.failureOrSuccessOption.fold(
        () {},
        (either) => either.fold(
          (failure) => _onFailure(failure, context),
          (_) => _onSuccess(context),
        ),
      );

  void _onFailure(Failure failure, BuildContext context) {
    final message = switch (failure) {
      ServerError() => 'Server error',
      EmailAlreadyInUse() => 'The email is already in use',
      UsernameAlreadyInUse() => 'The username is already in use',
      EmptyFields() => 'Some fields are empty',
      _ => 'Unexpected error',
    };
    FlushbarHelper.createError(
      duration: const Duration(seconds: 2),
      message: message,
    ).show(context);
  }

  void _onSuccess(BuildContext context) {
    context.read<AuthenticationBloc>().add(
      const AuthenticationEvent.authenticationCheckRequested(),
    );
    context.router.replaceAll([const TutorialRoute()]);
  }
}
