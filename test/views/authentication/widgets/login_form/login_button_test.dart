import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';
import 'package:pami/views/authentication/widgets/login_form/login_button.dart';

import 'login_button_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LoginFormBloc>()])
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
            child: const LoginButton(),
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
      expect(find.text('Log In'), findsOneWidget);
    },
  );

  testWidgets(
    'triggers loggedIn event when tapped',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockBloc.add(const LoginFormEvent.loggedIn())).called(1);
    },
  );
}
