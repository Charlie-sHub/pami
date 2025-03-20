import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/shout_out.dart';

/// Google map widget
class MapWidget extends StatelessWidget {
  /// Default constructor
  const MapWidget({
    required this.markers,
    super.key,
  });

  /// Markers to display
  final Set<ShoutOut> markers;

  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: Colors.blue,
        child: Center(
          child: Text('Google Map goes here'),
        ),
      );
}
