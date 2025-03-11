import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/views/core/misc/open_picture_select_dialog.dart';
import 'package:pami/views/core/widgets/image_picker_dialog.dart';

void main() {
  Widget buildWidget() => MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async => openPictureSelectDialog(
                context,
              ),
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      );

  testWidgets(
    'openPictureSelectDialog opens ImagePickerDialog',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ImagePickerDialog), findsOneWidget);
    },
  );
}
