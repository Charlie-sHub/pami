import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/core/widgets/app_widget.dart';

@Deprecated('Prefer the use of either main dev or prod to run the app')
void main() {
  // await dotenv.load();
  configureDependencies(Environment.dev);
  runApp(const AppWidget());
}
