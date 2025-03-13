import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:pami/views/tutorial/data/tutorial_slides.dart';
import 'package:pami/views/tutorial/widgets/tutorial_button.dart';
import 'package:pami/views/tutorial/widgets/tutorial_carousel.dart';
import 'package:pami/views/tutorial/widgets/tutorial_indicator.dart';

/// Tutorial page for the app
@RoutePage()
class TutorialPage extends StatefulWidget {
  /// Default constructor
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Expanded(
              child: TutorialCarousel(
                slides: tutorialSlides,
                controller: _controller,
                onPageChanged: (int index) => setState(
                  () => _currentIndex = index,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TutorialIndicator(
              slideCount: tutorialSlides.length,
              currentIndex: _currentIndex,
              controller: _controller,
            ),
            const SizedBox(height: 40),
            TutorialButton(isLast: _currentIndex == tutorialSlides.length - 1),
            const SizedBox(height: 20),
          ],
        ),
      );
}
