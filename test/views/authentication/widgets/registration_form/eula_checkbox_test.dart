import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/views/authentication/widgets/registration_form/eula_checkbox.dart';

import 'eula_checkbox_test.mocks.dart';

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
            child: const EulaCheckbox(),
          ),
        ),
      );

  testWidgets(
    'renders correctly',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(CheckboxListTile), findsOneWidget);
      expect(
        find.text('Do you agree with our terms and services?'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'triggers tappedEULA event on tap',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();

      // Assert
      verify(mockBloc.add(const RegistrationFormEvent.tappedEULA())).called(1);
    },
  );

  testWidgets(
    'displays error message when EULA is not accepted '
    'and showErrorMessages is true',
    (tester) async {
      // Arrange
      final invalidState = RegistrationFormState.initial().copyWith(
        showErrorMessages: true,
        acceptedEULA: false,
      );
      when(mockBloc.state).thenAnswer((_) => invalidState);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please check the EULA'), findsOneWidget);
    },
  );

  testWidgets(
    'does not display error message when EULA is accepted',
    (tester) async {
      // Arrange
      final validState = RegistrationFormState.initial().copyWith(
        showErrorMessages: true,
        acceptedEULA: true,
      );
      when(mockBloc.state).thenAnswer((_) => validState);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please check the EULA'), findsNothing);
    },
  );

  testWidgets(
    'does not display error message when showErrorMessages is false',
    (tester) async {
      // Arrange
      final validState = RegistrationFormState.initial().copyWith(
        showErrorMessages: false,
        acceptedEULA: false,
      );
      when(mockBloc.state).thenAnswer((_) => validState);

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please check the EULA'), findsNothing);
    },
  );
}
