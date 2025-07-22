import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/views/core/routes/router.gr.dart';
import 'package:pami/views/tutorial/widgets/tutorial_button.dart';

import 'tutorial_button_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<StackRouter>(),
])
void main() {
  late MockStackRouter mockRouter;

  setUp(
    () {
      mockRouter = MockStackRouter();
      when(mockRouter.replace(any)).thenAnswer(
        (_) async => null,
      );
    },
  );

  Widget buildWidget({bool isLast = false}) => MaterialApp(
    home: StackRouterScope(
      controller: mockRouter,
      stateHash: 0,
      child: Scaffold(
        body: TutorialButton(isLast: isLast),
      ),
    ),
  );

  testWidgets(
    'TutorialButton renders Skip Tutorial text when isLast is false',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Skip Tutorial'), findsOneWidget);
    },
  );

  testWidgets(
    'TutorialButton renders Get Started! text when isLast is true',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(isLast: true));

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Get Started!'), findsOneWidget);
    },
  );

  testWidgets(
    'TutorialButton navigates to HomeRoute when tapped',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(isLast: true));
      await tester.tap(find.byType(TutorialButton));

      // Assert
      verify(mockRouter.replace(const HomeRoute())).called(1);
    },
  );
}
