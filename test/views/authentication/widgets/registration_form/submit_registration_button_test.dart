import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/views/authentication/widgets/registration_form/submit_registration_button.dart';

import 'submit_registration_button_test.mocks.dart';

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
            child: const SubmitRegistrationButton(),
          ),
        ),
      );

  testWidgets(
    'renders ElevatedButton when not submitting',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    },
  );

  testWidgets(
    'renders CircularProgressIndicator when submitting',
    (tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer(
        (_) => RegistrationFormState.initial().copyWith(
          isSubmitting: true,
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'triggers submitted event when ElevatedButton is tapped',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockBloc.add(const RegistrationFormEvent.submitted())).called(1);
    },
  );

  testWidgets(
    'does not trigger submitted event when submitting',
    (tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer(
        (_) => RegistrationFormState.initial().copyWith(isSubmitting: true),
      );

      // Act
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(CircularProgressIndicator));
      await tester.pump();

      // Assert
      verifyNever(mockBloc.add(const RegistrationFormEvent.submitted()));
    },
  );
}
