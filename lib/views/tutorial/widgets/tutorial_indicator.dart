import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

/// Indicator for the tutorial carousel
class TutorialIndicator extends StatelessWidget {
  /// Default constructor
  const TutorialIndicator({
    required this.slideCount,
    required this.currentIndex,
    required this.controller,
    super.key,
  });

  /// Total number of slides
  final int slideCount;

  /// Current active slide index
  final int currentIndex;

  /// Carousel controller
  final CarouselSliderController controller;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          slideCount,
          (index) => GestureDetector(
            onTap: () => controller.animateToPage(index),
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index
                    ? Colors.black.withValues(alpha: 0.8)
                    : Colors.black.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
      );
}
