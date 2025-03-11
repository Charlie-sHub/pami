import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/views/authentication/widgets/login_form/register_button.dart';
import 'package:pami/views/core/routes/router.gr.dart';

import 'register_button_test.mocks.dart';

@GenerateNiceMocks([MockSpec<StackRouter>()])
void main() {
  late MockStackRouter mockRouter;

  setUp(
    () {
      mockRouter = MockStackRouter();
      when(mockRouter.push(any)).thenAnswer((_) async => null);
    },
  );

  Widget buildWidget() => MaterialApp(
        home: StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: const Scaffold(
            body: RegisterButton(),
          ),
        ),
      );

  testWidgets(
    'renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    },
  );

  testWidgets(
    'navigates to RegistrationRoute when tapped',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockRouter.push(argThat(isA<RegistrationRoute>()))).called(1);
    },
  );
}
