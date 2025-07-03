import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/login_form/login_form_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/authentication/authentication_repository_interface.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/password.dart';

import 'login_form_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepositoryInterface>()])
void main() {
  late MockAuthenticationRepositoryInterface mockRepository;
  late LoginFormBloc logInFormBloc;

  const email = 'test@email.com';
  const password = 'Abcd*1234';
  final validUser = getValidUser();
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockAuthenticationRepositoryInterface();
      logInFormBloc = LoginFormBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<LoginFormBloc, LoginFormState>(
        'emits a state with the changed email when EmailChanged is added',
        build: () => logInFormBloc,
        act: (bloc) => bloc.add(
          const LoginFormEvent.emailChanged(email),
        ),
        expect: () => [
          LoginFormState.initial().copyWith(
            email: EmailAddress(email),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<LoginFormBloc, LoginFormState>(
        'emits state with the changed password when PasswordChanged is added',
        build: () => logInFormBloc,
        act: (bloc) => bloc.add(
          const LoginFormEvent.passwordChanged(password),
        ),
        expect: () => [
          LoginFormState.initial().copyWith(
            password: Password(password),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<LoginFormBloc, LoginFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(right(unit))] when email and '
        'password are valid and repository returns Right',
        setUp: () {
          when(
            mockRepository.logIn(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenAnswer((_) async => right(unit));
        },
        seed: () => LoginFormState.initial().copyWith(
          email: EmailAddress(email),
          password: Password(password),
        ),
        build: () => logInFormBloc,
        act: (bloc) => bloc.add(const LoginFormEvent.loggedIn()),
        verify: (_) => mockRepository.logIn(
          email: EmailAddress(email),
          password: Password(password),
        ),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: false,
            failureOrSuccessOption: some(right(unit)),
          ),
        ],
      );

      blocTest<LoginFormBloc, LoginFormState>(
        'emits [state, state] (first state is submitting and '
        'the latter is the result) when LoggedInGoogle is added and '
        'repository returns Right',
        build: () {
          when(mockRepository.logInGoogle()).thenAnswer(
            (_) async => right(some(validUser)),
          );
          return logInFormBloc;
        },
        act: (bloc) => bloc.add(const LoginFormEvent.loggedInGoogle()),
        verify: (_) => mockRepository.logInGoogle(),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            thirdPartyUserOption: none(),
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            thirdPartyUserOption: some(validUser),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<LoginFormBloc, LoginFormState>(
        'emits [state, state] (first state is submitting and '
        'the latter is the result) when LoggedInApple is added and '
        'repository returns Right',
        build: () {
          when(mockRepository.logInApple()).thenAnswer(
            (_) async => right(some(validUser)),
          );
          return logInFormBloc;
        },
        act: (bloc) => bloc.add(const LoginFormEvent.loggedInApple()),
        verify: (_) => mockRepository.logInApple(),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            thirdPartyUserOption: none(),
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            thirdPartyUserOption: some(validUser),
            failureOrSuccessOption: none(),
          ),
        ],
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<LoginFormBloc, LoginFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(right(unit))] when email and '
        'password are valid and repository returns Right',
        setUp: () {
          when(
            mockRepository.logIn(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenAnswer((_) async => left(failure));
        },
        seed: () => LoginFormState.initial().copyWith(
          email: EmailAddress(email),
          password: Password(password),
        ),
        build: () => logInFormBloc,
        act: (bloc) => bloc.add(const LoginFormEvent.loggedIn()),
        verify: (_) => mockRepository.logIn(
          email: EmailAddress(email),
          password: Password(password),
        ),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: false,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
      );

      blocTest<LoginFormBloc, LoginFormState>(
        'emits [state, state] (first state is submitting and '
        'the latter is the failure) when LoggedInGoogle is added and '
        'repository returns Left',
        build: () {
          when(mockRepository.logInGoogle()).thenAnswer(
            (_) async => left(failure),
          );
          return logInFormBloc;
        },
        seed: () => LoginFormState.initial().copyWith(
          email: EmailAddress(email),
          password: Password(password),
        ),
        act: (bloc) => bloc.add(const LoginFormEvent.loggedInGoogle()),
        verify: (_) => mockRepository.logInGoogle(),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
      );

      blocTest<LoginFormBloc, LoginFormState>(
        'emits [state, state] (first state is submitting and '
        'the latter is the failure) when LoggedInApple is added and '
        'repository returns Left',
        build: () {
          when(mockRepository.logInApple()).thenAnswer(
            (_) async => left(failure),
          );
          return logInFormBloc;
        },
        seed: () => LoginFormState.initial().copyWith(
          email: EmailAddress(email),
          password: Password(password),
        ),
        act: (bloc) => bloc.add(const LoginFormEvent.loggedInApple()),
        verify: (_) => mockRepository.logInApple(),
        expect: () => [
          logInFormBloc.state.copyWith(
            isSubmitting: true,
            failureOrSuccessOption: none(),
          ),
          logInFormBloc.state.copyWith(
            isSubmitting: false,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
      );
    },
  );
}
