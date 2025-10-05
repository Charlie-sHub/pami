import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Scan QR page
@RoutePage()
class ScanPage extends StatefulWidget {
  /// Default constructor
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Scan the QR code')),
    body: MobileScanner(
      controller: _controller,
      onDetect: (capture) async {
        final codes = capture.barcodes;
        if (codes.isNotEmpty) {
          final raw = codes.first.rawValue;
          if (raw != null && raw.isNotEmpty) {
            await _controller.stop();
            if (context.mounted) {
              Navigator.of(context).pop(raw);
            }
          }
        }
      },
    ),
  );
}
