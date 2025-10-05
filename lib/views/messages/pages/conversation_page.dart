import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/shout_out.dart';

/// Conversation page for each [ShoutOut]
@RoutePage()
class ConversationPage extends StatelessWidget {
  /// Default constructor
  const ConversationPage({required this.shoutOut, super.key});

  /// The [ShoutOut] of the conversation
  // Might not need the entire shout out object, but it's worth giving for now
  final ShoutOut shoutOut;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(shoutOut.title.getOrCrash()),
    ),
  );
}
