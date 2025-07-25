import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

/// Pop-up card's image slider widget
class ShoutOutModalImageSlider extends StatelessWidget {
  /// Default constructor
  const ShoutOutModalImageSlider({
    required this.imageUrls,
    super.key,
  });

  /// Urls to display
  final Set<Url> imageUrls;

  @override
  Widget build(BuildContext context) => imageUrls.isEmpty
      ? const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 80,
            color: Colors.grey,
          ),
        )
      : CarouselSlider(
          options: CarouselOptions(
            height: 150,
            enableInfiniteScroll: false,
            viewportFraction: 1,
          ),
          items: imageUrls.map(_mapUrls).toList(),
        );

  ClipRRect _mapUrls(Url url) => url.value.fold(
    (_) => ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 150,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.broken_image,
            color: Colors.grey,
            size: 50,
          ),
        ),
      ),
    ),
    (validUrl) => ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        validUrl,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    ),
  );
}
