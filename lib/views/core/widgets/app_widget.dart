import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pami/l10n/l10n.dart';
import 'package:pami/views/core/theme/theme.dart';

/// App's entry widget
class AppWidget extends StatelessWidget {
  /// Default constructor
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'PAMI',
        theme: appTheme,
        supportedLocales: L10n.all,
        locale: L10n.all.first,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const Scaffold(
          body: Center(
            child: Text(
              'PLACEHOLDER',
            ),
          ),
        ),
      );
}
