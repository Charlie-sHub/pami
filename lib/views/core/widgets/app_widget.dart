import 'package:flutter/material.dart';
import 'package:pami/views/core/theme/theme.dart';

/// App's entry widget
class AppWidget extends StatelessWidget {
  /// Default constructor
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PAMI',
      theme: appTheme,
      home: const Scaffold(
        body: Center(
          child: Text(
            'PLACEHOLDER',
          ),
        ),
      ),
    );
  }
}
