import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';
import 'package:pami/views/authentication/widgets/login_form/login_apple_button.dart';
import 'package:pami/views/authentication/widgets/login_form/login_button.dart';
import 'package:pami/views/authentication/widgets/login_form/login_form.dart';
import 'package:pami/views/authentication/widgets/login_form/login_google_button.dart';
import 'package:pami/views/authentication/widgets/login_form/login_trouble_button.dart';
import 'package:pami/views/authentication/widgets/login_form/register_button.dart';
import 'package:pami/views/authentication/widgets/password_text_field.dart';

import 'login_form_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoginFormBloc>(),
  MockSpec<StackRouter>(),
])
void main() {
  late MockLoginFormBloc mockBloc;
  late MockStackRouter mockRouter;

  setUp(
    () {
      mockBloc = MockLoginFormBloc();
      mockRouter = MockStackRouter();
      when(mockRouter.push(any)).thenAnswer((_) async => null);
      when(mockRouter.replace(any)).thenAnswer((_) async => null);
    },
  );

  tearDown(
    () async => mockBloc.close(),
  );

  Widget buildWidget() => MaterialApp(
        home: StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider<LoginFormBloc>.value(
            value: mockBloc,
            child: const Scaffold(
              body: LoginForm(),
            ),
          ),
        ),
      );

  testWidgets(
    'renders all expected widgets',
    (tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(LoginFormState.initial());

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('PAMI'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(PasswordTextField), findsOneWidget);
      expect(find.byType(LoginButton), findsOneWidget);
      expect(find.byType(LoginTroubleButton), findsOneWidget);
      expect(find.byType(LoginAppleButton), findsOneWidget);
      expect(find.byType(LoginGoogleButton), findsOneWidget);
      expect(find.byType(RegisterButton), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Did you forget your password?'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    },
  );

  testWidgets(
    'shows validation error for invalid email',
    (tester) async {
      // Arrange
      final invalidState = LoginFormState.initial().copyWith(
        showErrorMessages: true,
      );
      when(mockBloc.state).thenReturn(invalidState);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Invalid email'), findsOneWidget);
    },
  );

  testWidgets(
    'shows validation error for empty password',
    (tester) async {
      // Arrange
      final emptyPasswordState = LoginFormState.initial().copyWith(
        showErrorMessages: true,
      );
      when(mockBloc.state).thenReturn(emptyPasswordState);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Empty password'), findsOneWidget);
    },
  );
}
