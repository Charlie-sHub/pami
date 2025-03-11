import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/views/authentication/widgets/login_form/login_trouble_button.dart';
import 'package:pami/views/core/routes/router.gr.dart';

import 'login_trouble_button_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<StackRouter>(),
])
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
            body: LoginTroubleButton(),
          ),
        ),
      );

  testWidgets(
    'renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Did you forget your password?'), findsOneWidget);
    },
  );

  testWidgets(
    'navigates to ForgotPasswordRoute when tapped',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(TextButton));
      await tester.pump();

      // Assert
      verify(mockRouter.push(const ForgotPasswordRoute())).called(1);
    },
  );
}
