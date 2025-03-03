import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/authentication/authentication/authentication_bloc.dart';
import 'package:pami/views/core/routes/router.gr.dart';
import 'package:pami/views/splash/widgets/pami_loading_animation.dart';

/// The Splash Page widget
/// Checks for authentication and routes the user to either
/// the [HomeRoute] or the [LoginRoute]
@RoutePage()
class SplashPage extends StatelessWidget {
  /// Default constructor
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: _listener,
        child: const Scaffold(
          body: PamiLoadingAnimation(),
        ),
      );

  void _listener(BuildContext context, AuthenticationState state) =>
      switch (state) {
        Initial() => null,
        Authenticated() => context.router.replace(
            const HomeRoute(),
          ),
        UnAuthenticated() => context.router.replace(
            const LoginRoute(),
          ),
      };
}
