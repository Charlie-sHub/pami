import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/map/map_settings_form/map_settings_form_bloc.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/views/map/widgets/map_settings_sheet.dart';

import 'map_settings_sheet_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MapSettingsFormBloc>(),
])
void main() {
  late MockMapSettingsFormBloc mockMapSettingsFormBloc;

  final initialState = MapSettingsFormState.initial();

  setUp(
    () {
      mockMapSettingsFormBloc = MockMapSettingsFormBloc();
      provideDummy<MapSettingsFormState>(initialState);
      when(mockMapSettingsFormBloc.state).thenReturn(
        initialState,
      );
      when(
        mockMapSettingsFormBloc.stream,
      ).thenAnswer((_) => Stream.value(initialState));
    },
  );

  tearDown(
    () => mockMapSettingsFormBloc.close(),
  );

  Widget buildWidget() => MaterialApp(
    home: Scaffold(
      body: BlocProvider<MapSettingsFormBloc>.value(
        value: mockMapSettingsFormBloc,
        child: const MapSettingsSheet(),
      ),
    ),
  );

  testWidgets(
    'renders main interactive elements based on initial bloc state',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(DropdownButton<ShoutOutType>), findsOneWidget);
      expect(find.byType(ChoiceChip), findsAtLeastNWidgets(1));
      expect(find.widgetWithText(TextButton, 'Reset'), findsOneWidget);
      expect(find.text('Radius: 10.0 km'), findsOneWidget);
      expect(
        find.widgetWithText(ChoiceChip, Category.food.name),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'adds radiusChanged event to bloc when Slider is changed',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.drag(find.byType(Slider), const Offset(50, 0));
      await tester.pump();

      // Assert
      verify(
        mockMapSettingsFormBloc.add(
          const MapSettingsFormEvent.radiusChanged(11),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'adds typeChanged event to bloc when DropdownButton is changed',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(DropdownButton<ShoutOutType>));
      await tester.pumpAndSettle();
      final itemToSelect = ShoutOutType.values.firstWhere(
        (type) => type != initialState.settings.type,
      );
      await tester.tap(find.text(itemToSelect.name).last);
      await tester.pumpAndSettle();

      // Assert
      verify(
        mockMapSettingsFormBloc.add(
          MapSettingsFormEvent.typeChanged(itemToSelect),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'adds categoriesChanged event to bloc when a ChoiceChip is tapped',
    (tester) async {
      // Arrange
      const categoryToTap = Category.hygiene;
      final currentCategories = initialState.settings.categories;
      final expectedCategories = Set<Category>.from(currentCategories)
        ..remove(categoryToTap);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, categoryToTap.name));
      await tester.pump();

      // Assert
      verify(
        mockMapSettingsFormBloc.add(
          MapSettingsFormEvent.categoriesChanged(expectedCategories),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'adds resetSettings event to bloc when Reset button is tapped',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.widgetWithText(TextButton, 'Reset'));
      await tester.pump();

      // Assert
      verify(
        mockMapSettingsFormBloc.add(const MapSettingsFormEvent.resetSettings()),
      ).called(1);
    },
  );
}
