import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/views/authentication/widgets/registration_form/username_text_field.dart';

import 'username_text_field_test.mocks.dart';

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
              child: UsernameTextField(
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
      expect(find.text('Username'), findsOneWidget);
      expect(find.byIcon(Icons.account_box), findsOneWidget);
    },
  );

  testWidgets(
    'triggers usernameChanged event on change',
    (tester) async {
      // Arrange
      const username = 'John_Doe';

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.enterText(find.byType(TextFormField), username);
      await tester.pump();

      // Assert
      verify(
        mockBloc.add(const RegistrationFormEvent.usernameChanged(username)),
      ).called(1);
    },
  );

  testWidgets(
    'sets initial value',
    (tester) async {
      // Arrange
      const initialUsername = 'Initial_username';

      // Act
      await tester.pumpWidget(buildWidget(initialValue: initialUsername));
      final usernameField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );

      // Assert
      expect(usernameField.initialValue, equals(initialUsername));
    },
  );

  testWidgets(
    'displays validation error',
    (tester) async {
      // Arrange
      const errorText = 'Empty username';
      final invalidState = RegistrationFormState.initial().copyWith(
        user: getValidUser().copyWith(username: Name('')),
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
