import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/views/authentication/widgets/registration_form/bio_text_field.dart';

import 'bio_text_field_test.mocks.dart';

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

  Widget buildWidget({String? initialValue}) => MaterialApp(
        home: Scaffold(
          body: BlocProvider<RegistrationFormBloc>.value(
            value: mockBloc,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: BioTextField(
                initialValue: initialValue,
              ),
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
      expect(find.text('Bio'), findsOneWidget);
      expect(find.byIcon(Icons.text_snippet), findsOneWidget);
    },
  );

  testWidgets(
    'triggers bioChanged event on change',
    (tester) async {
      // Arrange
      const bio = 'This is my bio';

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.enterText(find.byType(TextFormField), bio);
      await tester.pump();

      // Assert
      verify(
        mockBloc.add(const RegistrationFormEvent.bioChanged(bio)),
      ).called(1);
    },
  );

  testWidgets(
    'sets initial value',
    (tester) async {
      // Arrange
      const initialBio = 'Initial bio';

      // Act
      await tester.pumpWidget(buildWidget(initialValue: initialBio));
      final bioField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );

      // Assert
      expect(bioField.initialValue, equals(initialBio));
    },
  );

  testWidgets(
    'displays validation error',
    (tester) async {
      // Arrange
      const errorText = 'Empty bio';
      when(mockBloc.state).thenReturn(RegistrationFormState.initial());

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(errorText), findsOneWidget);
    },
  );
}
