import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/core/widgets/app_widget.dart';
import 'package:provider/provider.dart';

/// Common helper function that takes a given [Environment]
/// and runs the app with it
Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(environment);
  await dotenv.load();
  runApp(
    Provider(
      create: (context) => environment,
      child: const AppWidget(),
    ),
  );
}
