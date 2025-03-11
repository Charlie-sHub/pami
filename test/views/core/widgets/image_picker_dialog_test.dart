import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pami/views/core/widgets/image_picker_dialog.dart';

void main() {
  Widget buildWidget() => MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog<XFile>(
                context: context,
                builder: (context) => const ImagePickerDialog(),
              ),
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      );

  testWidgets(
    'renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Camera'), findsOneWidget);
      expect(find.byIcon(Icons.photo_camera), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.byIcon(Icons.grid_view), findsOneWidget);
    },
  );
}
