import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/authentication/authentication_bloc.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/authentication/pages/registration_page.dart';
import 'package:pami/views/authentication/widgets/registration_form/registration_form.dart';
import 'package:pami/views/core/routes/router.gr.dart';

import 'registration_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RegistrationFormBloc>(),
  MockSpec<StackRouter>(),
  MockSpec<AuthenticationBloc>(),
])
void main() {
  late MockRegistrationFormBloc mockBloc;
  late MockStackRouter mockRouter;
  late MockAuthenticationBloc mockAuthBloc;
  late StreamController<RegistrationFormState> streamController;

  setUp(
    () {
      mockBloc = MockRegistrationFormBloc();
      mockRouter = MockStackRouter();
      mockAuthBloc = MockAuthenticationBloc();
      streamController = StreamController<RegistrationFormState>.broadcast();
      getIt.registerFactory<RegistrationFormBloc>(() => mockBloc);
      provideDummy<RegistrationFormState>(RegistrationFormState.initial());
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(RegistrationFormState.initial());
      when(mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    },
  );

  tearDown(
    () async {
      await streamController.close();
      await mockBloc.close();
      await mockAuthBloc.close();
      await getIt.reset();
    },
  );

  Widget buildWidget({Option<User>? userOption}) => MaterialApp(
        home: StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider<AuthenticationBloc>.value(
            value: mockAuthBloc,
            child: RegistrationPage(userOption: userOption ?? none()),
          ),
        ),
      );

  testWidgets(
    'displays RegistrationForm and AppBar with correct title',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(RegistrationForm), findsOneWidget);
      expect(find.text('Registration'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    },
  );

  group(
    'Listener behavior tests',
    () {
      testWidgets(
        'Navigates to TutorialRoute on successful registration',
        (tester) async {
          // Arrange
          final successState = RegistrationFormState.initial().copyWith(
            failureOrSuccessOption: some(right(unit)),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(successState);
          await tester.pump();

          // Assert
          verify(mockRouter.replace(const TutorialRoute())).called(1);
          verify(
            mockAuthBloc.add(
              const AuthenticationEvent.authenticationCheckRequested(),
            ),
          ).called(1);
        },
      );

      testWidgets(
        'Shows error Flushbar on Server Error',
        (tester) async {
          // Arrange
          final failureState = RegistrationFormState.initial().copyWith(
            failureOrSuccessOption: some(
              left(const Failure.serverError(errorString: 'test error')),
            ),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(failureState);
          await tester.pump();

          // Assert
          expect(find.text('Server error'), findsOneWidget);
        },
      );

      testWidgets(
        'Shows error Flushbar on Email Already in Use',
        (tester) async {
          // Arrange
          final failureState = RegistrationFormState.initial().copyWith(
            failureOrSuccessOption: some(
              left(const Failure.emailAlreadyInUse()),
            ),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(failureState);
          await tester.pump();

          // Assert
          expect(find.text('The email is already in use'), findsOneWidget);
        },
      );

      testWidgets(
        'Shows error Flushbar on Username Already in Use',
        (tester) async {
          // Arrange
          final failureState = RegistrationFormState.initial().copyWith(
            failureOrSuccessOption: some(
              left(const Failure.usernameAlreadyInUse()),
            ),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(failureState);
          await tester.pump();

          // Assert
          expect(find.text('The username is already in use'), findsOneWidget);
        },
      );

      testWidgets(
        'Shows error Flushbar on Empty fields',
        (tester) async {
          // Arrange
          final failureState = RegistrationFormState.initial().copyWith(
            failureOrSuccessOption: some(left(const Failure.emptyFields())),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(failureState);
          await tester.pump();

          // Assert
          expect(find.text('Some fields are empty'), findsOneWidget);
        },
      );

      testWidgets(
        'Shows generic error Flushbar on unexpected error',
        (tester) async {
          // Arrange
          final failureState = RegistrationFormState.initial().copyWith(
            failureOrSuccessOption: some(
              left(const Failure.unexpectedError(errorMessage: 'test error')),
            ),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(failureState);
          await tester.pump();

          // Assert
          expect(find.byType(Flushbar), findsOneWidget);
        },
      );

      testWidgets(
        'Listener does not trigger for irrelevant state changes',
        (tester) async {
          // Arrange
          final newState = RegistrationFormState.initial().copyWith(
            isSubmitting: true,
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(newState);
          await tester.pump();

          // Assert
          expect(find.byType(Flushbar), findsNothing);
        },
      );
    },
  );
}
