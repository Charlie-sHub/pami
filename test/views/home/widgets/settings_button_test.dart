import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/views/core/routes/router.gr.dart';
import 'package:pami/views/home/widgets/settings_button.dart';

import 'settings_button_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<StackRouter>(),
])
void main() {
  late MockStackRouter mockRouter;

  setUp(
    () => mockRouter = MockStackRouter(),
  );

  Widget buildWidget() => MaterialApp(
        home: StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: const Scaffold(
            body: SettingsButton(),
          ),
        ),
      );

  testWidgets(
    'SettingsButton renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'SettingsButton navigates to SettingsRoute on tap',
    (tester) async {
      // Arrange
      when(mockRouter.push(any)).thenAnswer((_) async => null);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Assert
      verify(mockRouter.push(const SettingsRoute())).called(1);
    },
  );
}
