import 'dart:async';

import 'package:flutter/material.dart';

/// Animated PAMI loading indicator for splash screen
class PamiLoadingAnimation extends StatefulWidget {
  /// Default constructor
  const PamiLoadingAnimation({super.key});

  @override
  State<PamiLoadingAnimation> createState() => _PamiLoadingAnimationState();
}

class _PamiLoadingAnimationState extends State<PamiLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _letters = ['P', 'A', 'M', 'I'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
     unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final valueLength = _controller.value * _letters.length;
            final activeIndex = valueLength.floor() % _letters.length;

            return SizedBox(
              width: 140,
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(
                  _letters.length,
                  (index) {
                    var activity = 0.0;

                    if (index == activeIndex) {
                      final letterProgress = valueLength % 1.0;
                      activity = letterProgress < 0.5
                          ? letterProgress * 2
                          : 1.0 - ((letterProgress - 0.5) * 2);
                      activity = Curves.linear.transform(activity);
                    }

                    return Positioned(
                      left: index * 35.0,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: activity),
                        duration: const Duration(milliseconds: 100),
                        builder: (context, value, child) => Text(
                          _letters[index],
                          style: TextStyle(
                            fontSize: 20 + (value * 10),
                            color: Color.lerp(
                              Colors.grey.withValues(alpha: 0.7),
                              Theme.of(context).primaryColor,
                              value,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      );
}
