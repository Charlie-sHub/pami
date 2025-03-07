import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/forgotten_password_form/forgotten_password_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/authentication/widgets/forgot_password_form/forgot_password_form.dart';

/// Forgot password page for the app
@RoutePage()
class ForgotPasswordPage extends StatelessWidget {
  /// Default constructor
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Forgot Password'),
          ),
          body: BlocProvider(
            create: (context) => getIt<ForgottenPasswordFormBloc>(),
            child: BlocListener<ForgottenPasswordFormBloc,
                ForgottenPasswordFormState>(
              listenWhen: _listenWhen,
              listener: _listener,
              child: const ForgotPasswordForm(),
            ),
          ),
        ),
      );

  bool _listenWhen(
    ForgottenPasswordFormState previous,
    ForgottenPasswordFormState current,
  ) =>
      previous.failureOrSuccessOption != current.failureOrSuccessOption;

  void _listener(
    BuildContext context,
    ForgottenPasswordFormState state,
  ) =>
      state.failureOrSuccessOption.fold(
        () {},
        (either) => either.fold(
          (failure) => _onFailure(failure, context),
          (_) => _onSuccess(context),
        ),
      );

  void _onFailure(Failure failure, BuildContext context) {
    final message = switch (failure) {
      ServerError(:final errorString) => errorString,
      EmptyFields() => 'Empty Email Field',
      _ => 'Unexpected error',
    };
    FlushbarHelper.createError(
      duration: const Duration(seconds: 2),
      message: message,
    ).show(context);
  }

  void _onSuccess(BuildContext context) => FlushbarHelper.createSuccess(
        duration: const Duration(seconds: 8),
        message: 'Check your email for password reset instructions',
      ).show(context);
}
