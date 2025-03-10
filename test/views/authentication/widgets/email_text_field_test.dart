import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/views/authentication/widgets/email_text_field.dart';
import 'package:pami/views/core/misc/event_to_add_typedef.dart';

import 'email_text_field_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RegistrationFormBloc>(),
])
void main() {
  late MockRegistrationFormBloc mockBloc;
  late StreamController<RegistrationFormState> streamController;

  setUp(
    () {
      mockBloc = MockRegistrationFormBloc();
      streamController = StreamController.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(RegistrationFormState.initial());
    },
  );

  tearDown(
    () async {
      await streamController.close();
      await mockBloc.close();
    },
  );

  Widget buildWidget({
    required EventToAdd eventToAdd,
    required FormFieldValidator<String?> validator,
    String? initialValue,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<RegistrationFormBloc>.value(
            value: mockBloc,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: EmailTextField(
                eventToAdd: eventToAdd,
                validator: validator,
                initialValue: initialValue,
              ),
            ),
          ),
        ),
      );

  String emailValidator(RegistrationFormState state) =>
      state.user.email.value.fold(
        (failure) => switch (failure) {
          InvalidEmail() => 'Invalid email',
          _ => 'Unknown error',
        },
        (_) => '',
      );

  testWidgets(
    'renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(
        buildWidget(
          eventToAdd: (_) {},
          validator: (_) => null,
        ),
      );

      // Assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
    },
  );

  testWidgets(
    'triggers emailChanged event on change',
    (tester) async {
      // Arrange
      const email = 'test@example.com';
      await tester.pumpWidget(
        buildWidget(
          eventToAdd: (email) => mockBloc.add(
            RegistrationFormEvent.emailAddressChanged(email),
          ),
          validator: (_) => null,
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), email);
      await tester.pump();

      // Assert
      verify(
        mockBloc.add(
          const RegistrationFormEvent.emailAddressChanged(email),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'sets initial value',
    (tester) async {
      // Arrange
      const initialEmail = 'initial@example.com';
      await tester.pumpWidget(
        buildWidget(
          eventToAdd: (_) {},
          validator: (_) => null,
          initialValue: initialEmail,
        ),
      );

      // Act
      final emailField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );

      // Assert
      expect(emailField.initialValue, equals(initialEmail));
    },
  );

  testWidgets(
    'displays validation error',
    (tester) async {
      // Arrange
      const errorText = 'Invalid email';

      // Act
      await tester.pumpWidget(
        buildWidget(
          eventToAdd: (email) => mockBloc.add(
            RegistrationFormEvent.emailAddressChanged(email),
          ),
          validator: (email) => emailValidator(mockBloc.state),
        ),
      );
      streamController.add(RegistrationFormState.initial());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(errorText), findsOneWidget);
    },
  );
}
