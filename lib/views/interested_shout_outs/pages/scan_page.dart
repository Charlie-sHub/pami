import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Scan QR page
@RoutePage()
class ScanPage extends StatelessWidget {
  /// Default constructor
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Scan the QR code')),
    body: MobileScanner(
      onDetect: (capture) {
        final codes = capture.barcodes;
        if (codes.isNotEmpty) {
          final raw = codes.first.rawValue;
          if (raw != null && raw.isNotEmpty) {
            Navigator.of(context).pop(raw);
          }
        }
      },
    ),
  );
}
