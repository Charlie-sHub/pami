import 'package:flutter/material.dart';

/// App's entry widget
class AppWidget extends StatelessWidget {
  /// Default constructor
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PAMI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
