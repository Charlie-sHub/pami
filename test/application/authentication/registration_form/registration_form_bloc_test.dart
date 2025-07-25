import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/registration_form/registration_form_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/authentication/authentication_repository_interface.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/field_confirmator.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/password.dart';

import 'registration_form_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepositoryInterface>()])
void main() {
  late MockAuthenticationRepositoryInterface mockRepository;
  late RegistrationFormBloc registrationFormBloc;

  const name = 'Test Name';
  const username = 'testuser';
  const email = 'test@email.com';
  const password = 'Abcd*1234';
  const bio = 'Test bio';
  final validUser = getValidUser();
  final xFile = XFile('test_path.jpg');
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockAuthenticationRepositoryInterface();
      registrationFormBloc = RegistrationFormBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits initialized state with empty user when initialized with none',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(RegistrationFormEvent.initialized(none())),
        expect: () => [
          RegistrationFormState.initial().copyWith(
            // Bit of a workaround the UniqueId differences between the
            // registrationFormBloc.state and RegistrationFormState.initial()
            user: registrationFormBloc.state.user,
            initialized: true,
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits initialized state with provided user when initialized '
        'with some user',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(
          RegistrationFormEvent.initialized(some(validUser)),
        ),
        expect: () => [
          RegistrationFormState.initial().copyWith(
            user: validUser,
            initialized: true,
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits state with updated image when ImageChanged is added',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(
          RegistrationFormEvent.imageChanged(xFile),
        ),
        expect: () => [
          registrationFormBloc.state.copyWith(
            imageFile: some(xFile),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits state with updated name when NameChanged is added',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(const RegistrationFormEvent.nameChanged(name)),
        expect: () => [
          registrationFormBloc.state.copyWith(
            user: registrationFormBloc.state.user.copyWith(
              name: Name(name),
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits state with updated username when UsernameChanged is added',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(
          const RegistrationFormEvent.usernameChanged(username),
        ),
        expect: () => [
          registrationFormBloc.state.copyWith(
            user: registrationFormBloc.state.user.copyWith(
              username: Name(username),
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits state with updated email when EmailAddressChanged is added',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(
          const RegistrationFormEvent.emailAddressChanged(email),
        ),
        expect: () => [
          registrationFormBloc.state.copyWith(
            user: registrationFormBloc.state.user.copyWith(
              email: EmailAddress(email),
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits state with updated email confirmation when '
        'EmailConfirmationChanged is added',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(
          const RegistrationFormEvent.emailConfirmationChanged(email),
        ),
        expect: () => [
          registrationFormBloc.state.copyWith(
            emailConfirmator: FieldConfirmator(
              field: registrationFormBloc.state.user.email.value.fold(
                (failure) => '',
                id,
              ),
              confirmation: email,
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits state with updated bio when BioChanged is added',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(const RegistrationFormEvent.bioChanged(bio)),
        expect: () => [
          registrationFormBloc.state.copyWith(
            user: registrationFormBloc.state.user.copyWith(
              bio: EntityDescription(bio),
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits state with updated password when PasswordChanged is added',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(
          const RegistrationFormEvent.passwordChanged(password),
        ),
        expect: () => [
          registrationFormBloc.state.copyWith(
            password: Password(password),
            passwordConfirmator: FieldConfirmator(
              field: password,
              confirmation: registrationFormBloc.state.passwordToCompare,
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits state with updated password confirmation when '
        'PasswordConfirmationChanged is added',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(
          const RegistrationFormEvent.passwordConfirmationChanged(password),
        ),
        expect: () => [
          registrationFormBloc.state.copyWith(
            passwordConfirmator: FieldConfirmator(
              field: registrationFormBloc.state.password.value.fold(
                (failure) => '',
                id,
              ),
              confirmation: password,
            ),
            passwordToCompare: password,
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits state with updated EULA status when TappedEULA is added',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(const RegistrationFormEvent.tappedEULA()),
        expect: () => [
          registrationFormBloc.state.copyWith(
            acceptedEULA: true,
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(right(unit))] when registration data '
        'is valid and repository returns Right',
        setUp: () {
          when(
            mockRepository.register(
              user: anyNamed('user'),
              password: anyNamed('password'),
              imageFile: anyNamed('imageFile'),
            ),
          ).thenAnswer((_) async => right(unit));
        },
        build: () => registrationFormBloc,
        seed: () => RegistrationFormState.initial().copyWith(
          user: validUser,
          emailConfirmator: FieldConfirmator(
            field: email,
            confirmation: email,
          ),
          password: Password(password),
          passwordConfirmator: FieldConfirmator(
            field: password,
            confirmation: password,
          ),
          acceptedEULA: true,
          imageFile: some(XFile('test_path.jpg')),
        ),
        act: (bloc) => bloc.add(const RegistrationFormEvent.submitted()),
        expect: () => [
          registrationFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          registrationFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: false,
            failureOrSuccessOption: some(right(unit)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.register(
            user: anyNamed('user'),
            password: anyNamed('password'),
            imageFile: anyNamed('imageFile'),
          ),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(left(failure))] when submitted with '
        'invalid form data',
        build: () => registrationFormBloc,
        act: (bloc) => bloc.add(const RegistrationFormEvent.submitted()),
        expect: () => [
          registrationFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          registrationFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: none(),
          ),
        ],
        verify: (_) => verifyNever(
          mockRepository.register(
            user: anyNamed('user'),
            password: anyNamed('password'),
            imageFile: anyNamed('imageFile'),
          ),
        ),
      );

      blocTest<RegistrationFormBloc, RegistrationFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(left(failure))] when registration data '
        'is valid but repository returns Left',
        setUp: () {
          when(
            mockRepository.register(
              user: anyNamed('user'),
              password: anyNamed('password'),
              imageFile: anyNamed('imageFile'),
            ),
          ).thenAnswer((_) async => left(failure));
        },
        build: () => registrationFormBloc,
        seed: () => RegistrationFormState.initial().copyWith(
          user: validUser,
          emailConfirmator: FieldConfirmator(
            field: email,
            confirmation: email,
          ),
          password: Password(password),
          passwordConfirmator: FieldConfirmator(
            field: password,
            confirmation: password,
          ),
          acceptedEULA: true,
          imageFile: some(XFile('test_path.jpg')),
        ),
        act: (bloc) => bloc.add(const RegistrationFormEvent.submitted()),
        expect: () => [
          registrationFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          registrationFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: false,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.register(
            user: anyNamed('user'),
            password: anyNamed('password'),
            imageFile: anyNamed('imageFile'),
          ),
        ).called(1),
      );
    },
  );
}
