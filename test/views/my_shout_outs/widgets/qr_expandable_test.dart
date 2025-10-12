import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/views/core/theme/colors.dart';
import 'package:pami/views/my_shout_outs/widgets/qr_expandable.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(body: child),
  );

  testWidgets(
    'shows only the title when collapsed',
    (tester) async {
      // Arrange
      final id = UniqueId();
      final widget = QrExpandable(id: id);

      // Act
      await tester.pumpWidget(wrap(widget));

      // Assert
      expect(find.text('QR code'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsOneWidget);
      expect(find.byType(QrImageView), findsNothing);
      expect(find.text(id.getOrCrash()), findsNothing);
    },
  );

  testWidgets(
    'expands on tap and shows the QR plus id text',
    (tester) async {
      // Arrange
      final id = UniqueId();
      await tester.pumpWidget(wrap(QrExpandable(id: id)));

      // Act
      await tester.tap(find.text('QR code'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text(id.getOrCrash()), findsOneWidget);
    },
  );

  testWidgets(
    'passes color/style to QrImageView (eye & data modules)',
    (tester) async {
      // Arrange
      final id = UniqueId();
      await tester.pumpWidget(wrap(QrExpandable(id: id)));
      await tester.tap(find.text('QR code'));
      await tester.pumpAndSettle();

      // Act
      final qrFinder = find.byType(QrImageView);
      final qrWidget = tester.widget<QrImageView>(qrFinder);

      // Assert
      expect(qrWidget.eyeStyle.color, AppColors.primary);
      expect(qrWidget.dataModuleStyle.color, AppColors.primary);
      expect(qrWidget.size, 180);
    },
  );
}
