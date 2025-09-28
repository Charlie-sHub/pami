import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pami/domain/core/entities/user.dart';

/// Shows network avatar or initials fallback.
class UserAvatar extends StatelessWidget {
  /// Default constructor
  const UserAvatar({
    required this.size,
    required this.userOption,
    super.key,
  });

  /// Avatar size
  final double size;

  /// User to display
  final Option<User> userOption;

  @override
  Widget build(BuildContext context) {
    final imageUrl = userOption.fold<String?>(
      () => null,
      (user) => user.avatar.getOrCrash(),
    );

    final displayName = userOption.fold(
      () => null,
      (user) => user.name.getOrCrash(),
    );

    final initials = displayName != null ? _initials(displayName) : '?';

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
          ? NetworkImage(imageUrl)
          : null,
      child: (imageUrl == null || imageUrl.isEmpty)
          ? displayName == null
                ? const Icon(Icons.error, color: Colors.red)
                : Text(
                    initials,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  )
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
