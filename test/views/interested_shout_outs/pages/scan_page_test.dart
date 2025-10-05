import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/views/interested_shout_outs/pages/scan_page.dart';
import 'scan_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BarcodeCapture>(),
  MockSpec<Barcode>(),
])
void main() {
  Widget buildWidget(FutureOr<void> Function(BuildContext) onPush) =>
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Host')),
            body: Center(
              child: ElevatedButton(
                onPressed: () => onPush(context),
                child: const Text('Open Scanner'),
              ),
            ),
          ),
        ),
      );

  testWidgets(
    'renders AppBar and MobileScanner',
    (tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: ScanPage()));

      // Assert
      expect(find.text('Scan the QR code'), findsOneWidget);
      expect(find.byType(MobileScanner), findsOneWidget);
    },
  );

  testWidgets(
    'pops with payload when a QR with rawValue is detected',
    (tester) async {
      // Arrange
      late Future<dynamic> result;
      await tester.pumpWidget(
        buildWidget((context) {
          result = Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ScanPage()),
          );
        }),
      );

      // Act
      await tester.tap(find.text('Open Scanner'));
      await tester.pumpAndSettle();
      final scanner = tester.widget<MobileScanner>(
        find.byType(MobileScanner),
      );
      final mockCapture = MockBarcodeCapture();
      final mockBarcode = MockBarcode();
      when(mockBarcode.rawValue).thenReturn('12345');
      when(mockCapture.barcodes).thenReturn(<Barcode>[mockBarcode]);
      scanner.onDetect?.call(mockCapture);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Scan the QR code'), findsNothing);
      expect(await result, '12345');
    },
  );

  testWidgets(
    'does not pop when rawValue is null/empty',
    (tester) async {
      // Arrange
      late Future<dynamic> result;
      await tester.pumpWidget(
        buildWidget((context) {
          result = Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ScanPage()),
          );
        }),
      );

      await tester.tap(find.text('Open Scanner'));
      await tester.pumpAndSettle();
      final scanner = tester.widget<MobileScanner>(
        find.byType(MobileScanner),
      );

      // Act (empty string)
      final emptyCapture = MockBarcodeCapture();
      final emptyBarcode = MockBarcode();
      when(emptyBarcode.rawValue).thenReturn('');
      when(emptyCapture.barcodes).thenReturn(<Barcode>[emptyBarcode]);
      scanner.onDetect?.call(emptyCapture);
      await tester.pump();

      // Assert: still on page
      expect(find.text('Scan the QR code'), findsOneWidget);

      // Act (null)
      final nullCapture = MockBarcodeCapture();
      final nullBarcode = MockBarcode();
      when(nullBarcode.rawValue).thenReturn(null);
      when(nullCapture.barcodes).thenReturn(<Barcode>[nullBarcode]);
      scanner.onDetect?.call(nullCapture);
      await tester.pump();

      // Assert: still on page & future not completed
      expect(find.text('Scan the QR code'), findsOneWidget);
      var completed = false;
      unawaited(result.then((_) => completed = true));
      await tester.pump(const Duration(milliseconds: 100));
      expect(completed, isFalse);
    },
  );
}
