import 'dart:math' as math;
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
    final karmaPercent = user.karma.getOrCrash();
    final imageUrl = user.avatar.value.fold(
      (_) => null,
      (value) => value.isEmpty ? null : value,
    );

    final displayName = user.name.value.fold(
      (_) => null,
      (value) => value.isEmpty ? null : value,
    );

    final initials = displayName != null ? _initials(displayName) : '?';

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _KarmaRingPainter(karmaPercent: karmaPercent),
          ),
          CircleAvatar(
            radius: size / 2,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                ? NetworkImage(imageUrl)
                : null,
            child: imageUrl == null
                ? (displayName != null
                      ? Text(
                          initials,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                        )
                      : const Icon(Icons.person_outline))
                : null,
          ),
        ],
      ),
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

class _KarmaRingPainter extends CustomPainter {
  _KarmaRingPainter({required this.karmaPercent});

  final double karmaPercent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) + 4;
    const strokeWidth = 6.0;
    final backgroundPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final foregroundPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    const startAngle = math.pi / 2;
    const sweepAngleBg = 2 * math.pi;
    final sweepAngleFg = 2 * math.pi * (karmaPercent / 100);
    canvas
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngleBg,
        false,
        backgroundPaint,
      )
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngleFg,
        false,
        foregroundPaint,
      );
  }

  @override
  bool shouldRepaint(covariant _KarmaRingPainter oldDelegate) =>
      oldDelegate.karmaPercent != karmaPercent;
}
