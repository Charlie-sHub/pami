import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/views/authentication/widgets/registration_form/name_text_field.dart';

import 'name_text_field_test.mocks.dart';

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

  tearDown(() async => mockBloc.close());

  Widget buildWidget({String? initialValue}) => MaterialApp(
        home: Scaffold(
          body: BlocProvider<RegistrationFormBloc>.value(
            value: mockBloc,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: NameTextField(
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
      expect(find.text('Name'), findsOneWidget);
      expect(find.byIcon(Icons.account_box), findsOneWidget);
    },
  );

  testWidgets(
    'triggers nameChanged event on change',
    (tester) async {
      // Arrange
      const name = 'John Doe';

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.enterText(find.byType(TextFormField), name);
      await tester.pump();

      // Assert
      verify(
        mockBloc.add(const RegistrationFormEvent.nameChanged(name)),
      ).called(1);
    },
  );

  testWidgets(
    'sets initial value',
    (tester) async {
      // Arrange
      const initialName = 'Initial Name';

      // Act
      await tester.pumpWidget(buildWidget(initialValue: initialName));
      final nameField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );

      // Assert
      expect(nameField.initialValue, equals(initialName));
    },
  );

  testWidgets(
    'displays validation error',
    (tester) async {
      // Arrange
      const errorText = 'Empty name';
      final invalidState = RegistrationFormState.initial().copyWith(
        user: getValidUser().copyWith(name: Name('')),
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
