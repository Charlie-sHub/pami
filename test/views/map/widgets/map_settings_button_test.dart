import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/map/map_settings_form/map_settings_form_bloc.dart';
import 'package:pami/views/map/widgets/map_settings_button.dart';
import 'package:pami/views/map/widgets/map_settings_sheet.dart';

import 'map_settings_button_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MapSettingsFormBloc>(),
])
void main() {
  late MockMapSettingsFormBloc mockMapSettingsFormBloc;

  setUp(
    () {
      mockMapSettingsFormBloc = MockMapSettingsFormBloc();
      provideDummy<MapSettingsFormState>(
        MapSettingsFormState.initial(),
      );
    },
  );

  tearDown(
    () => mockMapSettingsFormBloc.close(),
  );

  Widget buildWidget() => MaterialApp(
    home: Scaffold(
      body: BlocProvider<MapSettingsFormBloc>.value(
        value: mockMapSettingsFormBloc,
        child: const MapSettingsButton(),
      ),
    ),
  );

  testWidgets(
    'renders correctly as a FloatingActionButton with an Icon',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);
      final fab = tester.widget<FloatingActionButton>(fabFinder);
      expect(fab.mini, isTrue);
      expect(fab.heroTag, isNull);
      expect(
        fab.shape,
        equals(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
      expect(
        find.descendant(
          of: fabFinder,
          matching: find.byIcon(Icons.tune),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'shows MapSettingsSheet in a modal bottom sheet when tapped',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MapSettingsSheet), findsOneWidget);
      final mapSettingsSheetFinder = find.byType(MapSettingsSheet);
      final BuildContext sheetContext = tester.element(mapSettingsSheetFinder);
      expect(
        BlocProvider.of<MapSettingsFormBloc>(sheetContext),
        mockMapSettingsFormBloc,
      );
    },
  );
}
