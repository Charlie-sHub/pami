import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/application/authentication/authentication/authentication_bloc.dart';
import 'package:pami/injection.dart';
import 'package:pami/l10n/l10n.dart';
import 'package:pami/src/generated/i18n/app_localizations.dart';
import 'package:pami/views/core/routes/router.dart';
import 'package:pami/views/core/theme/theme.dart';
import 'package:provider/provider.dart';

/// App's entry widget
class AppWidget extends StatelessWidget {
  /// Default constructor
  AppWidget({super.key});

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    final showBanner = Provider.of<String>(context) != Environment.prod;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthenticationBloc>(),
          // TODO: ..add(const AuthenticationEvent.authenticationCheckRequested(),)
        ),
      ],
      child: MaterialApp.router(
        title: 'PAMI',
        debugShowCheckedModeBanner: showBanner,
        theme: appTheme,
        routerDelegate: _router.delegate(),
        routeInformationParser: _router.defaultRouteParser(),
        supportedLocales: L10n.all,
        locale: L10n.all.first,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
