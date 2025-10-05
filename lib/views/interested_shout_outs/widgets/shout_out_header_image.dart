import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

/// Image carousel and dismiss icon button
class ShoutOutHeaderImage extends StatelessWidget {
  /// Default constructor
  const ShoutOutHeaderImage({
    required this.imageUrls,
    required this.id,
    super.key,
  });

  /// List of image URLs to display
  final List<Url> imageUrls;

  /// Dismiss action
  final UniqueId id;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 16 / 9,
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrls.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              final sliderHeight = constraints.maxHeight;
              return CarouselSlider.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index, _) => SizedBox.expand(
                  child: Image.network(
                    imageUrls[index].getOrCrash(),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: Colors.grey,
                    ),
                  ),
                ),
                options: CarouselOptions(
                  height: sliderHeight,
                  viewportFraction: 1,
                  enableInfiniteScroll: imageUrls.length > 1,
                  autoPlay: imageUrls.length > 1,
                ),
              );
            },
          )
        else
          Container(color: Colors.grey),
        Positioned(
          top: -4,
          right: -4,
          child: IconButton(
            onPressed: () => context.read<InterestedShoutOutsActorBloc>().add(
              InterestedShoutOutsActorEvent.addToInterested(shoutOutId: id),
            ),
            icon: const Icon(Icons.close),
            tooltip: 'Not interested',
            style: IconButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.all(10),
              iconSize: 24,
            ),
          ),
        ),
      ],
    ),
  );
}
