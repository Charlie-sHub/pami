import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

/// Image + title overlay + dismiss icon (Stack)
class ShoutOutHeaderImage extends StatefulWidget {
  /// Default constructor
  const ShoutOutHeaderImage({
    required this.title,
    required this.imageUrls,
    required this.onDismiss,
    super.key,
  });

  /// Title to display
  final String title;

  /// List of image URLs to display
  final List<Url> imageUrls; // pass already-unwrapped URLs
  /// Dismiss action
  final VoidCallback onDismiss;

  @override
  State<ShoutOutHeaderImage> createState() => _ShoutOutHeaderImageState();
}

class _ShoutOutHeaderImageState extends State<ShoutOutHeaderImage> {
  static const double _headerHeight = 160;
  final _controller = CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _headerHeight,
    width: double.infinity,
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (widget.imageUrls.isNotEmpty)
          CarouselSlider.builder(
            carouselController: _controller,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index, realIdx) => Image.network(
              widget.imageUrls[index].getOrCrash(),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: Colors.grey[300],
              ),
            ),
            options: CarouselOptions(
              height: _headerHeight,
              viewportFraction: 1,
              enableInfiniteScroll: widget.imageUrls.length > 1,
              autoPlay: widget.imageUrls.length > 1,
              onPageChanged: (idx, reason) => setState(
                () => _current = idx,
              ),
            ),
          )
        else
          Container(color: Colors.grey[300]),
        Positioned(
          left: 12,
          bottom: 12,
          right: 52,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(150),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: 12,
            right: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.imageUrls.length, (index) {
                final active = index == _current;
                return Container(
                  width: active ? 10 : 8,
                  height: active ? 10 : 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white70,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            onPressed: widget.onDismiss,
            icon: const Icon(Icons.close, size: 20),
            tooltip: 'Not interested',
          ),
        ),
      ],
    ),
  );
}
