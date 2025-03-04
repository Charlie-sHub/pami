import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/authentication/authentication_bloc.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/authentication/widgets/login_form/login_form.dart';
import 'package:pami/views/core/routes/router.gr.dart';

/// Login page widget
class LoginPage extends StatelessWidget {
  /// Default constructor
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: BlocProvider.value(
            value: getIt<LoginFormBloc>(),
            child: BlocConsumer<LoginFormBloc, LoginFormState>(
              listenWhen: (previous, current) =>
                  previous.failureOrSuccessOption !=
                      current.failureOrSuccessOption ||
                  previous.isSubmitting != current.isSubmitting ||
                  current.thirdPartyUserOption.isSome(),
              listener: (context, state) => state.thirdPartyUserOption.fold(
                () => state.failureOrSuccessOption.fold(
                  () {},
                  (either) => either.fold(
                    (failure) => _onFailure(failure, context),
                    (_) => _onSuccess(context),
                  ),
                ),
                (thirdPartyUser) => context.router.push(
                  RegistrationRoute(
                    userOption: some(thirdPartyUser),
                  ),
                ),
              ),
              buildWhen: (previous, current) =>
                  previous.showErrorMessages != current.showErrorMessages,
              builder: (context, state) => const LoginForm(),
            ),
          ),
        ),
      );

  Future _onFailure(Failure failure, BuildContext context) {
    final message = switch (failure) {
      CancelledByUser() => 'Cancelled',
      InvalidCredentials() => 'Invalid credentials',
      UnregisteredUser() => 'Unregistered user',
      UnexpectedError() => 'Unexpected error',
      _ => 'Unexpected error',
    };

    return FlushbarHelper.createError(
      duration: const Duration(seconds: 2),
      message: message,
    ).show(context);
  }

  void _onSuccess(BuildContext context) {
    context.router.replace(const HomeRoute());
    context.read<AuthenticationBloc>().add(
          const AuthenticationEvent.authenticationCheckRequested(),
        );
  }
}
