import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pami/views/tutorial/widgets/tutorial_slide.dart';

/// Carousel for displaying tutorial slides
class TutorialCarousel extends StatelessWidget {
  /// Default constructor
  const TutorialCarousel({
    required this.slides,
    required this.controller,
    required this.onPageChanged,
    super.key,
  });

  /// List of slides
  final List<Map<String, String>> slides;

  /// Carousel controller
  final CarouselSliderController controller;

  /// Callback when page changes
  final void Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) => CarouselSlider.builder(
    itemCount: slides.length,
    carouselController: controller,
    options: CarouselOptions(
      height: MediaQuery.of(context).size.height * 0.7,
      enableInfiniteScroll: false,
      viewportFraction: 1,
      onPageChanged: (index, _) => onPageChanged(index),
    ),
    itemBuilder: (context, index, _) {
      final slide = slides[index];
      return TutorialSlide(
        title: slide['title']!,
        description: slide['description']!,
      );
    },
  );
}
