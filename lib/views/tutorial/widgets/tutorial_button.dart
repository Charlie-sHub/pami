import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pami/views/core/routes/router.gr.dart';

/// Tutorial button widget
class TutorialButton extends StatelessWidget {
  /// Default constructor
  const TutorialButton({
    required this.isLast,
    super.key,
  });

  /// Indicates if the button is on the last slide
  final bool isLast;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          onPressed: () => context.router.replace(const HomeRoute()),
          child: Text(
            isLast ? 'Get Started!' : 'Skip Tutorial',
          ),
        ),
      );
}
