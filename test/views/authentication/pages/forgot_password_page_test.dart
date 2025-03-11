import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/forgotten_password_form/forgotten_password_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/authentication/pages/forgot_password_page.dart';
import 'package:pami/views/authentication/widgets/forgot_password_form/forgot_password_form.dart';

import 'forgot_password_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ForgottenPasswordFormBloc>(),
  MockSpec<StackRouter>(),
])
void main() {
  late MockForgottenPasswordFormBloc mockBloc;
  late MockStackRouter mockRouter;
  late StreamController<ForgottenPasswordFormState> streamController;

  setUp(
    () {
      mockBloc = MockForgottenPasswordFormBloc();
      mockRouter = MockStackRouter();
      streamController = StreamController.broadcast();
      getIt.registerFactory<ForgottenPasswordFormBloc>(() => mockBloc);
      provideDummy<ForgottenPasswordFormState>(
        ForgottenPasswordFormState.initial(),
      );

      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(ForgottenPasswordFormState.initial());
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
          child: const ForgotPasswordPage(),
        ),
      );

  testWidgets(
    'displays ForgotPasswordForm and AppBar with correct title',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(ForgotPasswordForm), findsOneWidget);
      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    },
  );

  group(
    'Listener behavior tests',
    () {
      testWidgets(
        'Shows success Flushbar on successful password reset request',
        (tester) async {
          // Arrange
          final successState = ForgottenPasswordFormState.initial().copyWith(
            failureOrSuccessOption: some(right(unit)),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(successState);
          await tester.pump();

          // Assert
          expect(
            find.text('Check your email for password reset instructions'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'Shows error Flushbar on empty fields',
        (tester) async {
          // Arrange
          final failureState = ForgottenPasswordFormState.initial().copyWith(
            failureOrSuccessOption: some(left(const EmptyFields())),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(failureState);
          await tester.pump();

          // Assert
          expect(find.text('Empty Email Field'), findsOneWidget);
        },
      );

      testWidgets(
        'Shows error Flushbar with server error message',
        (tester) async {
          // Arrange
          final failureState = ForgottenPasswordFormState.initial().copyWith(
            failureOrSuccessOption: some(
              left(const ServerError(errorString: 'Server unavailable')),
            ),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(failureState);
          await tester.pump();

          // Assert
          expect(find.text('Server unavailable'), findsOneWidget);
        },
      );

      testWidgets(
        'Shows generic error Flushbar on unexpected error',
        (tester) async {
          // Arrange
          final failureState = ForgottenPasswordFormState.initial().copyWith(
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
          final newState = ForgottenPasswordFormState.initial().copyWith(
            email: EmailAddress('new@example.com'),
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
