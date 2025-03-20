import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/password.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/authentication/widgets/email_text_field.dart';
import 'package:pami/views/authentication/widgets/password_text_field.dart';
import 'package:pami/views/authentication/widgets/registration_form/bio_text_field.dart';
import 'package:pami/views/authentication/widgets/registration_form/email_confirmator_text_field.dart';
import 'package:pami/views/authentication/widgets/registration_form/eula_checkbox.dart';
import 'package:pami/views/authentication/widgets/registration_form/name_text_field.dart';
import 'package:pami/views/authentication/widgets/registration_form/password_confirmator_text_field.dart';
import 'package:pami/views/authentication/widgets/registration_form/registration_form.dart';
import 'package:pami/views/authentication/widgets/registration_form/submit_registration_button.dart';
import 'package:pami/views/authentication/widgets/registration_form/user_image_picker.dart';
import 'package:pami/views/authentication/widgets/registration_form/username_text_field.dart';

import 'registration_form_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RegistrationFormBloc>(),
  MockSpec<StackRouter>(),
])
void main() {
  late MockRegistrationFormBloc mockBloc;
  late MockStackRouter mockRouter;

  setUp(() {
    mockBloc = MockRegistrationFormBloc();
    mockRouter = MockStackRouter();
    getIt.registerFactory<RegistrationFormBloc>(() => mockBloc);
    when(mockBloc.state).thenReturn(RegistrationFormState.initial());
    when(mockRouter.push(any)).thenAnswer((_) async => null);
    when(mockRouter.replace(any)).thenAnswer((_) async => null);
  });

  tearDown(() async {
    await mockBloc.close();
    await getIt.reset();
  });

  Widget buildWidget({Option<User>? userOption}) => MaterialApp(
        home: StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider<RegistrationFormBloc>.value(
            value: mockBloc,
            child: Scaffold(
              body: RegistrationForm(userOption: userOption ?? none()),
            ),
          ),
        ),
      );

  testWidgets(
    'renders all expected widgets',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );

      // Assert
      expect(find.text('PAMI'), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byKey(const Key('singleChildScrollView')), findsOneWidget);
      expect(find.byType(UserImagePicker), findsOneWidget);
      expect(find.byType(EmailTextField), findsOneWidget);
      expect(find.byType(EmailConfirmatorTextField), findsOneWidget);
      expect(find.byType(PasswordTextField), findsOneWidget);
      expect(find.byType(PasswordConfirmatorTextField), findsOneWidget);
      expect(find.byType(NameTextField), findsOneWidget);
      expect(find.byType(UsernameTextField), findsOneWidget);
      expect(find.byType(BioTextField), findsOneWidget);
      expect(find.byType(EulaCheckbox), findsOneWidget);
      expect(find.byType(SubmitRegistrationButton), findsOneWidget);
    },
  );

  testWidgets(
    'clicking SubmitRegistrationButton triggers submitted event',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SubmitRegistrationButton));
      await tester.pump();

      // Assert
      verify(
        mockBloc.add(const RegistrationFormEvent.submitted()),
      ).called(1);
    },
  );

  testWidgets(
    'Submitting with a valid form does not display error messages',
    (tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        RegistrationFormState.initial().copyWith(
          showErrorMessages: true,
          user: getValidUser(),
        ),
      );

      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.text('Invalid email'), findsNothing);
      expect(find.text('Empty password'), findsNothing);
      expect(find.text('Invalid password'), findsNothing);
    },
  );

  group(
    'Validation tests',
    () {
      testWidgets(
        'shows validation error for invalid email',
        (tester) async {
          // Arrange
          when(mockBloc.state).thenReturn(
            RegistrationFormState.initial().copyWith(
              showErrorMessages: true,
              user: getValidUser().copyWith(
                email: EmailAddress('invalid-email'),
              ),
            ),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          await tester.pump();

          // Assert
          expect(find.text('Invalid email'), findsOneWidget);
        },
      );

      testWidgets(
        'shows validation error for empty password',
        (tester) async {
          // Arrange
          when(mockBloc.state).thenReturn(
            RegistrationFormState.initial().copyWith(
              showErrorMessages: true,
              user: getValidUser(),
              password: Password(''),
            ),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          await tester.pump();

          // Assert
          expect(find.text('Empty password'), findsOneWidget);
        },
      );

      testWidgets(
        'shows validation error for invalid password',
        (tester) async {
          // Arrange
          when(mockBloc.state).thenReturn(
            RegistrationFormState.initial().copyWith(
              showErrorMessages: true,
              user: getValidUser(),
              password: Password('invalid-password'),
            ),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          await tester.pump();

          // Assert
          expect(find.text('Invalid password'), findsOneWidget);
        },
      );
    },
  );
}
