import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/user.dart';

/// Shows a user's avatar from the network
/// falls back to initials or an icon
class UserAvatar extends StatelessWidget {
  /// Default constructor
  const UserAvatar({
    required this.size,
    required this.user,
    super.key,
  });

  /// Avatar size
  final double size;

  /// User to display
  final User user;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.avatar.value.fold(
      (_) => null,
      (value) => value.isEmpty ? null : value,
    );

    final displayName = user.name.value.fold(
      (_) => null,
      (value) => value.isEmpty ? null : value,
    );

    final initials = displayName != null ? _initials(displayName) : '?';

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
          ? NetworkImage(imageUrl)
          : null,
      child: imageUrl == null
          ? (displayName != null
                ? Text(
                    initials,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : const Icon(Icons.person_outline))
          : null,
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.isEmpty ? '?' : parts.first[0].toUpperCase();
    }
    final first = parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    final second = parts[1].isNotEmpty ? parts[1][0].toUpperCase() : '?';
    return '$first$second';
  }
}
