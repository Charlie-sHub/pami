import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/authentication/authentication_bloc.dart';
import 'package:pami/views/core/routes/router.gr.dart';

/// The Splash Page widget
/// Checks for authentication and routes the user to either
/// the HomePage or the LoginPage
@RoutePage()
class SplashPage extends StatelessWidget {
  /// Default constructor
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: _listener,
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      );

  void _listener(BuildContext context, AuthenticationState state) => state.when(
        initial: () => null,
        authenticated: (_) => context.router.replace(
          const HomeRoute(),
        ),
        unAuthenticated: () => context.router.replace(
          const LoginRoute(),
        ),
      );
}
