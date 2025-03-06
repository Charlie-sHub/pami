import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/authentication/authentication_bloc.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/authentication/pages/login_page.dart';
import 'package:pami/views/authentication/widgets/login_form/login_form.dart';
import 'package:pami/views/core/routes/router.gr.dart';

import 'login_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoginFormBloc>(),
  MockSpec<AuthenticationBloc>(),
  MockSpec<StackRouter>(),
])
void main() {
  late MockLoginFormBloc mockBloc;
  late MockAuthenticationBloc mockAuthBloc;
  late MockStackRouter mockRouter;
  late StreamController<LoginFormState> streamController;

  setUp(
    () {
      mockBloc = MockLoginFormBloc();
      mockAuthBloc = MockAuthenticationBloc();
      mockRouter = MockStackRouter();
      streamController = StreamController<LoginFormState>.broadcast();
      getIt.registerFactory<LoginFormBloc>(() => mockBloc);
      provideDummy<LoginFormState>(LoginFormState.initial());
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(LoginFormState.initial());
    },
  );

  tearDown(
    () async {
      await streamController.close();
      await mockBloc.close();
      await getIt.reset();
    },
  );

  Widget buildWidget() => MaterialApp(
        home: StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider<AuthenticationBloc>.value(
            value: mockAuthBloc,
            child: const LoginPage(),
          ),
        ),
      );

  testWidgets(
    'displays LoginForm',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(LoginForm), findsOneWidget);
    },
  );

  group(
    'Listener tests',
    () {
      testWidgets(
        'Navigates to HomeRoute on successful login',
        (tester) async {
          // Arrange
          final initialState = LoginFormState.initial();
          final successState = initialState.copyWith(
            failureOrSuccessOption: some(right(unit)),
            isSubmitting: false,
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(successState);
          await tester.pumpAndSettle();

          // Assert
          verify(mockRouter.replace(const HomeRoute())).called(1);
          verify(
            mockAuthBloc.add(
              const AuthenticationEvent.authenticationCheckRequested(),
            ),
          ).called(1);
        },
      );

      testWidgets(
        'Shows error Flushbar on invalid credentials',
        (tester) async {
          // Arrange
          final initialState = LoginFormState.initial();
          final failureState = initialState.copyWith(
            failureOrSuccessOption: some(left(const InvalidCredentials())),
            isSubmitting: false,
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(failureState);
          await tester.pump();

          // Assert
          expect(find.text('Invalid credentials'), findsOneWidget);
        },
      );

      testWidgets(
        'Shows error Flushbar on unregistered user',
        (tester) async {
          // Arrange
          final initialState = LoginFormState.initial();
          final failureState = initialState.copyWith(
            failureOrSuccessOption: some(left(const UnregisteredUser())),
            isSubmitting: false,
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(failureState);
          await tester.pump();

          // Assert
          expect(find.text('Unregistered user'), findsOneWidget);
        },
      );

      testWidgets(
        'Shows error Flushbar on unexpected error',
        (tester) async {
          // Arrange
          final initialState = LoginFormState.initial();
          final failureState = initialState.copyWith(
            failureOrSuccessOption: some(
              left(
                const Failure.unexpectedError(errorMessage: 'test error'),
              ),
            ),
            isSubmitting: false,
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(failureState);
          await tester.pump();

          // Assert
          expect(find.text('Unexpected error'), findsOneWidget);
        },
      );

      testWidgets(
        'Navigates to RegistrationRoute with third party user',
        (tester) async {
          // Arrange
          final initialState = LoginFormState.initial();
          final userOption = some(getValidUser());
          final thirdPartyUserState = initialState.copyWith(
            thirdPartyUserOption: userOption,
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(thirdPartyUserState);
          await tester.pump();

          // Assert
          verify(mockRouter.push(argThat(isA<RegistrationRoute>()))).called(1);
        },
      );
    },
  );

  group(
    'BlocListener behavior tests',
    () {
      testWidgets(
        'Listener triggers when failureOrSuccessOption changes',
        (tester) async {
          // Arrange
          final initialState = LoginFormState.initial();
          final newState = initialState.copyWith(
            failureOrSuccessOption: some(right(unit)),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(initialState);
          await tester.pump();
          streamController.add(newState);
          await tester.pumpAndSettle();

          // Assert
          verify(mockRouter.replace(const HomeRoute())).called(1);
        },
      );

      testWidgets(
        'Listener triggers when isSubmitting changes to false with success',
        (tester) async {
          // Arrange
          final initialState = LoginFormState.initial().copyWith(
            isSubmitting: true,
          );
          final newState = initialState.copyWith(
            isSubmitting: false,
            failureOrSuccessOption: some(right(unit)),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(initialState);
          await tester.pump();
          streamController.add(newState);
          await tester.pumpAndSettle();

          // Assert
          verify(mockRouter.replace(const HomeRoute())).called(1);
        },
      );

      testWidgets(
        'Listener triggers when thirdPartyUserOption becomes some',
        (tester) async {
          // Arrange
          final initialState = LoginFormState.initial();
          final userOption = some(getValidUser());
          final newState = initialState.copyWith(
            thirdPartyUserOption: userOption,
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(initialState);
          await tester.pump();
          streamController.add(newState);
          await tester.pump();

          // Assert
          verify(mockRouter.push(argThat(isA<RegistrationRoute>()))).called(1);
        },
      );

      testWidgets(
        'Listener does not trigger for irrelevant state changes',
        (tester) async {
          // Arrange
          final initialState = LoginFormState.initial();
          final newState = initialState.copyWith(
            // Change something that shouldn't trigger the listener
            email: EmailAddress('new@example.com'),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(initialState);
          await tester.pump();
          streamController.add(newState);
          await tester.pump();

          // Assert - verify no navigation happened
          verifyNever(mockRouter.replace(any));
          verifyNever(mockRouter.push(any));
        },
      );
    },
  );
}
