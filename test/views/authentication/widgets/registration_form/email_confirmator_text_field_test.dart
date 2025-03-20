import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/validation/objects/field_confirmator.dart';
import 'package:pami/views/authentication/widgets/registration_form/email_confirmator_text_field.dart';

import 'email_confirmator_text_field_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RegistrationFormBloc>(),
])
void main() {
  late MockRegistrationFormBloc mockBloc;

  setUp(
    () {
      mockBloc = MockRegistrationFormBloc();
      when(mockBloc.state).thenReturn(RegistrationFormState.initial());
    },
  );

  tearDown(
    () async => mockBloc.close(),
  );

  Widget buildWidget() => MaterialApp(
        home: Scaffold(
          body: BlocProvider<RegistrationFormBloc>.value(
            value: mockBloc,
            child: const Form(
              autovalidateMode: AutovalidateMode.always,
              child: EmailConfirmatorTextField(),
            ),
          ),
        ),
      );

  testWidgets(
    'renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Email confirmation'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
    },
  );

  testWidgets(
    'triggers emailConfirmationChanged event on change',
    (tester) async {
      // Arrange
      const emailConfirmation = 'test@example.com';

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.enterText(find.byType(TextFormField), emailConfirmation);
      await tester.pump();

      // Assert
      verify(
        mockBloc.add(
          const RegistrationFormEvent.emailConfirmationChanged(
            emailConfirmation,
          ),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'displays validation error for empty email confirmation',
    (tester) async {
      // Arrange
      const errorText = 'Empty email confirmation';
      final invalidState = RegistrationFormState.initial().copyWith(
        showErrorMessages: true,
        emailConfirmator: FieldConfirmator(
          field: '',
          confirmation: '',
        ),
      );
      when(mockBloc.state).thenAnswer((_) => invalidState);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Assert
      expect(find.text(errorText), findsOneWidget);
    },
  );

  testWidgets(
    'displays validation error for mismatching emails',
    (tester) async {
      // Arrange
      const errorText = 'Mismatching emails';
      const validEmail = 'test@example.com';
      final invalidState = RegistrationFormState.initial().copyWith(
        showErrorMessages: true,
        emailConfirmator: FieldConfirmator(
          field: validEmail,
          confirmation: 'invalid@example.com',
        ),
      );
      when(mockBloc.state).thenAnswer((_) => invalidState);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Assert
      expect(find.text(errorText), findsOneWidget);
    },
  );
}
