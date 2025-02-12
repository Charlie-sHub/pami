import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/forgotten_password_form_bloc/forgotten_password_form_bloc.dart';
import 'package:pami/domain/authentication/authentication_repository_interface.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';

import 'forgotten_password_form_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepositoryInterface>()])
void main() {
  late MockAuthenticationRepositoryInterface mockRepository;
  late ForgottenPasswordFormBloc forgottenPasswordFormBloc;

  const validEmail = 'test@email.com';
  const invalidEmail = 'invalid-email';
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockAuthenticationRepositoryInterface();
      forgottenPasswordFormBloc = ForgottenPasswordFormBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<ForgottenPasswordFormBloc, ForgottenPasswordFormState>(
        'emits a state with the changed email when EmailChanged is added',
        build: () => forgottenPasswordFormBloc,
        act: (bloc) => bloc.add(
          const ForgottenPasswordFormEvent.emailChanged(validEmail),
        ),
        expect: () => [
          ForgottenPasswordFormState.initial().copyWith(
            email: EmailAddress(validEmail),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<ForgottenPasswordFormBloc, ForgottenPasswordFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, failureOrSuccessOption: some(right(unit))]'
        ' when email is valid and repository returns Right',
        setUp: () {
          when(
            mockRepository.resetPassword(any),
          ).thenAnswer((_) async => right(unit));
        },
        seed: () => ForgottenPasswordFormState.initial().copyWith(
          email: EmailAddress(validEmail),
        ),
        build: () => forgottenPasswordFormBloc,
        act: (bloc) => bloc.add(
          const ForgottenPasswordFormEvent.submitted(),
        ),
        expect: () => [
          forgottenPasswordFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          forgottenPasswordFormBloc.state.copyWith(
            isSubmitting: false,
            failureOrSuccessOption: some(right(unit)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.resetPassword(EmailAddress(validEmail)),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<ForgottenPasswordFormBloc, ForgottenPasswordFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, failureOrSuccessOption: some(left(failure))]'
        ' when email is valid and repository returns Left',
        setUp: () {
          when(mockRepository.resetPassword(any))
              .thenAnswer((_) async => left(failure));
        },
        seed: () => ForgottenPasswordFormState.initial().copyWith(
          email: EmailAddress(validEmail),
        ),
        build: () => forgottenPasswordFormBloc,
        act: (bloc) => bloc.add(
          const ForgottenPasswordFormEvent.submitted(),
        ),
        expect: () => [
          forgottenPasswordFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          forgottenPasswordFormBloc.state.copyWith(
            isSubmitting: false,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.resetPassword(
            EmailAddress(validEmail),
          ),
        ).called(1),
      );

      blocTest<ForgottenPasswordFormBloc, ForgottenPasswordFormState>(
        'emits [showErrorMessages: true, failureOrSuccessOption: '
        'some(left(Failure.emptyFields()))] when email is invalid',
        seed: () => ForgottenPasswordFormState.initial().copyWith(
          email: EmailAddress(invalidEmail),
        ),
        build: () => forgottenPasswordFormBloc,
        act: (bloc) => bloc.add(
          const ForgottenPasswordFormEvent.submitted(),
        ),
        expect: () => [
          forgottenPasswordFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          forgottenPasswordFormBloc.state.copyWith(
            showErrorMessages: true,
            failureOrSuccessOption: some(
              left(const Failure.emptyFields()),
            ),
          ),
        ],
        verify: (_) => verifyNever(
          mockRepository.resetPassword(any),
        ),
      );
    },
  );
}
