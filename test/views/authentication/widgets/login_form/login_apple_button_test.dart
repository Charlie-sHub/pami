import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';
import 'package:pami/views/authentication/widgets/login_form/login_apple_button.dart';

import 'login_apple_button_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoginFormBloc>(),
])
void main() {
  late MockLoginFormBloc mockBloc;

  setUp(
    () {
      mockBloc = MockLoginFormBloc();
      when(mockBloc.state).thenReturn(LoginFormState.initial());
    },
  );

  tearDown(
    () async => mockBloc.close(),
  );

  Widget buildWidget() => MaterialApp(
        home: Scaffold(
          body: BlocProvider<LoginFormBloc>.value(
            value: mockBloc,
            child: const LoginAppleButton(),
          ),
        ),
      );

  testWidgets(
    'renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(IconButton), findsOneWidget);
    },
  );

  testWidgets(
    'triggers loggedInApple event when tapped',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Assert
      verify(mockBloc.add(const LoginFormEvent.loggedInApple())).called(1);
    },
  );
}
