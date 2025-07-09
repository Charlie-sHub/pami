import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/shout_out.dart';

/// Shout out tile widget
class ShoutOutTile extends StatelessWidget {
  /// Default constructor
  const ShoutOutTile({
    required this.shout,
    super.key,
  });

  /// Shout out to display
  final ShoutOut shout;

  @override
  Widget build(BuildContext context) => ListTile(
    /*
      // TODO: Add Creator to the shoutouts
      leading: CircleAvatar(
        backgroundImage: NetworkImage(shout.posterAvatarUrl),
      ),
      subtitle: Text(shout.creator.name.getOrCrash()),
      */
    title: Text(shout.title.getOrCrash()),
  );
}
