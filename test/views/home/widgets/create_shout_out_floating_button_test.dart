import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/views/core/routes/router.gr.dart';
import 'package:pami/views/home/widgets/create_shout_out_floating_button.dart';

import 'create_shout_out_floating_button_test.mocks.dart';

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
          child: Scaffold(
            body: Container(),
            floatingActionButton: const CreateShoutOutFloatingButton(),
          ),
        ),
      );

  testWidgets(
    'CreateShoutOutFloatingButton renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'CreateShoutOutFloatingButton navigates to ShoutOutCreationRoute',
    (tester) async {
      // Arrange
      when(mockRouter.push(any)).thenAnswer((_) async => null);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert
      verify(mockRouter.push(argThat(isA<ShoutOutCreationRoute>()))).called(1);
    },
  );
}
