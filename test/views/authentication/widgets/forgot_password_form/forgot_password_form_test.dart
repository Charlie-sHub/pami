import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/forgotten_password_form/forgotten_password_form_bloc.dart';
import 'package:pami/views/authentication/widgets/email_text_field.dart';
import 'package:pami/views/authentication/widgets/forgot_password_form/forgot_password_form.dart';

import 'forgot_password_form_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ForgottenPasswordFormBloc>(),
  MockSpec<StackRouter>(),
])
void main() {
  late MockForgottenPasswordFormBloc mockBloc;
  late MockStackRouter mockRouter;

  setUp(
    () {
      mockBloc = MockForgottenPasswordFormBloc();
      mockRouter = MockStackRouter();
      when(mockBloc.state).thenReturn(ForgottenPasswordFormState.initial());
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
          child: BlocProvider<ForgottenPasswordFormBloc>.value(
            value: mockBloc,
            child: const Scaffold(
              body: ForgotPasswordForm(),
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
      expect(find.byType(EmailTextField), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);
    },
  );

  testWidgets(
    'typing in EmailTextField triggers emailChanged event',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.enterText(
        find.byType(EmailTextField),
        'test@example.com',
      );

      // Assert
      verify(
        mockBloc.add(
          const ForgottenPasswordFormEvent.emailChanged('test@example.com'),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'clicking Reset Password button triggers submitted event',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.text('Reset Password'));

      // Assert
      verify(
        mockBloc.add(const ForgottenPasswordFormEvent.submitted()),
      ).called(1);
    },
  );

  testWidgets(
    'shows validation error for invalid email',
    (tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        ForgottenPasswordFormState.initial().copyWith(
          showErrorMessages: true,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Assert
      expect(find.text('Invalid email'), findsOneWidget);
    },
  );
}
