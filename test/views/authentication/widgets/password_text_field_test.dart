import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/password.dart';
import 'package:pami/views/authentication/widgets/password_text_field.dart';
import 'package:pami/views/core/misc/event_to_add_typedef.dart';

import 'password_text_field_test.mocks.dart';

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
  }) =>
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<RegistrationFormBloc>.value(
            value: mockBloc,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: PasswordTextField(
                eventToAdd: eventToAdd,
                validator: validator,
              ),
            ),
          ),
        ),
      );

  String passwordValidator(RegistrationFormState state) =>
      state.password.value.fold(
        (failure) => switch (failure) {
          InvalidPassword() => 'Invalid password',
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
      expect(find.text('Password'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    },
  );

  testWidgets(
    'triggers passwordChanged event on change',
    (tester) async {
      // Arrange
      const password = 'testPassword123';

      // Act
      await tester.pumpWidget(
        buildWidget(
          eventToAdd: (password) => mockBloc.add(
            RegistrationFormEvent.passwordChanged(password),
          ),
          validator: (_) => null,
        ),
      );
      await tester.enterText(find.byType(TextFormField), password);
      await tester.pump();

      // Assert
      verify(
        mockBloc.add(
          const RegistrationFormEvent.passwordChanged(password),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'displays validation error',
    (tester) async {
      // Arrange
      const errorText = 'Invalid password';
      when(mockBloc.state).thenAnswer(
        (_) => RegistrationFormState.initial().copyWith(
          showErrorMessages: true,
          password: Password('short'),
        ),
      );

      // Act
      await tester.pumpWidget(
        buildWidget(
          eventToAdd: (password) => mockBloc.add(
            RegistrationFormEvent.passwordChanged(password),
          ),
          validator: (_) => passwordValidator(mockBloc.state),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(errorText), findsOneWidget);
    },
  );
}
