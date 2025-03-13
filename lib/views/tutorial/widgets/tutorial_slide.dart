import 'package:flutter/material.dart';
import 'package:pami/views/core/theme/text_styles.dart';

/// A single tutorial slide
class TutorialSlide extends StatelessWidget {
  /// Default constructor
  const TutorialSlide({
    required this.title,
    required this.description,
    super.key,
  });

  /// The title of the slide
  final String title;

  /// The description of the slide
  final String description;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge,
            ),
          ],
        ),
      );
}
