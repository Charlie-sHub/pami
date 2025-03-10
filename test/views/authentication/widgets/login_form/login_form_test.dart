import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';
import 'package:pami/views/authentication/widgets/login_form/login_apple_button.dart';
import 'package:pami/views/authentication/widgets/login_form/login_form.dart';
import 'package:pami/views/authentication/widgets/login_form/login_google_button.dart';
import 'package:pami/views/authentication/widgets/login_form/register_button.dart';
import 'package:pami/views/core/routes/router.gr.dart';

import 'login_form_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoginFormBloc>(),
  MockSpec<StackRouter>(),
])
void main() {
  late MockLoginFormBloc mockBloc;
  late MockStackRouter mockRouter;
  late StreamController<LoginFormState> streamController;

  setUp(
    () {
      mockBloc = MockLoginFormBloc();
      mockRouter = MockStackRouter();
      streamController = StreamController<LoginFormState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(LoginFormState.initial());
      when(mockRouter.push(any)).thenAnswer((_) async => null);
      when(mockRouter.replace(any)).thenAnswer((_) async => null);
    },
  );

  tearDown(
    () async {
      await streamController.close();
      await mockBloc.close();
    },
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
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('PAMI'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Did you forget your password?'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(LoginAppleButton), findsOneWidget);
      expect(find.byType(LoginGoogleButton), findsOneWidget);
    },
  );

  group(
    'Text fields tests',
    () {
      testWidgets(
        'typing in EmailTextField triggers emailChanged event',
        (tester) async {
          // Act
          await tester.pumpWidget(buildWidget());
          await tester.enterText(
            find.byType(TextFormField).first,
            'test@example.com',
          );

          // Assert
          verify(
            mockBloc.add(const LoginFormEvent.emailChanged('test@example.com')),
          ).called(1);
        },
      );

      testWidgets(
        'typing in PasswordTextField triggers passwordChanged event',
        (tester) async {
          // Act
          await tester.pumpWidget(buildWidget());
          await tester.enterText(
            find.byType(TextFormField).last,
            'password123',
          );

          // Assert
          verify(
            mockBloc.add(const LoginFormEvent.passwordChanged('password123')),
          ).called(1);
        },
      );
    },
  );

  group(
    'Button tests',
    () {
      testWidgets(
        'clicking LoginButton triggers loggedIn event',
        (tester) async {
          // Act
          await tester.pumpWidget(buildWidget());
          await tester.tap(find.text('Log In'));

          // Assert
          verify(mockBloc.add(const LoginFormEvent.loggedIn())).called(1);
        },
      );

      testWidgets(
        'clicking LoginGoogleButton triggers loggedInGoogle event',
        (tester) async {
          // Act
          await tester.pumpWidget(buildWidget());
          await tester.tap(find.byType(LoginGoogleButton));

          // Assert
          verify(mockBloc.add(const LoginFormEvent.loggedInGoogle())).called(1);
        },
      );

      testWidgets(
        'clicking LoginAppleButton triggers loggedInApple event',
        (tester) async {
          // Act
          await tester.pumpWidget(buildWidget());
          await tester.tap(find.byType(LoginAppleButton));

          // Assert
          verify(mockBloc.add(const LoginFormEvent.loggedInApple())).called(1);
        },
      );

      testWidgets(
        'clicking LoginTroubleButton navigates to ForgotPasswordRoute',
        (tester) async {
          // Act
          await tester.pumpWidget(buildWidget());
          await tester.tap(find.text('Did you forget your password?'));

          // Assert
          verify(mockRouter.push(const ForgotPasswordRoute())).called(1);
        },
      );

      testWidgets(
        'clicking RegisterButton navigates to RegistrationRoute',
        (tester) async {
          // Arrange
          final buttonFinder = find.byType(RegisterButton);
          final scrollableFinder = find.descendant(
            of: find.byKey(const Key('singleChildScrollView')),
            matching: find.byType(Scrollable).at(0),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          await tester.pumpAndSettle();
          await tester.scrollUntilVisible(
            buttonFinder,
            50,
            scrollable: scrollableFinder,
          );
          await tester.tap(buttonFinder);

          // Assert
          verify(
            mockRouter.push(argThat(isA<RegistrationRoute>())),
          ).called(1);
        },
      );
    },
  );

  group(
    'Validation tests',
    () {
      testWidgets(
        'shows validation error for invalid email',
        (tester) async {
          // Arrange
          final invalidState = LoginFormState.initial().copyWith(
            showErrorMessages: true,
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(invalidState);
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

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(emptyPasswordState);
          await tester.pumpAndSettle();

          // Assert
          expect(find.text('Empty password'), findsOneWidget);
        },
      );
    },
  );
}
