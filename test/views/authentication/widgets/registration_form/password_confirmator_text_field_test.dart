import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/validation/objects/field_confirmator.dart';
import 'package:pami/views/authentication/widgets/registration_form/password_confirmator_text_field.dart';

import 'password_confirmator_text_field_test.mocks.dart';

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
    () async {
      await mockBloc.close();
    },
  );

  Widget buildWidget() => MaterialApp(
        home: Scaffold(
          body: BlocProvider<RegistrationFormBloc>.value(
            value: mockBloc,
            child: const Form(
              autovalidateMode: AutovalidateMode.always,
              child: PasswordConfirmatorTextField(),
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
      expect(find.text('Password confirmation'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    },
  );

  testWidgets(
    'triggers passwordConfirmationChanged event on change',
    (tester) async {
      // Arrange
      const passwordConfirmation = 'testPassword123';

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.enterText(
        find.byType(TextFormField),
        passwordConfirmation,
      );
      await tester.pump();

      // Assert
      verify(
        mockBloc.add(
          const RegistrationFormEvent.passwordConfirmationChanged(
            passwordConfirmation,
          ),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'displays validation error for empty password confirmation',
    (tester) async {
      // Arrange
      const errorText = 'Empty password confirmation';
      final invalidState = RegistrationFormState.initial().copyWith(
        showErrorMessages: true,
        passwordConfirmator: FieldConfirmator(
          field: '',
          confirmation: '',
        ),
      );
      when(mockBloc.state).thenAnswer((_) => invalidState);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(errorText), findsOneWidget);
    },
  );

  testWidgets(
    'displays validation error for mismatching passwords',
    (tester) async {
      // Arrange
      const errorText = 'Mismatching passwords';
      final invalidState = RegistrationFormState.initial().copyWith(
        showErrorMessages: true,
        passwordConfirmator: FieldConfirmator(
          field: 'password',
          confirmation: 'invalidPassword',
        ),
      );
      when(mockBloc.state).thenAnswer((_) => invalidState);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(errorText), findsOneWidget);
    },
  );
}
