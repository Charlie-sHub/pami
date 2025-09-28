import 'package:flutter/material.dart';

/// Shared rounded outline button
class PillButton extends StatelessWidget {
  /// Default constructor
  const PillButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// Button label
  final String label;

  /// Button action
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    child: Text(label),
  );
}
