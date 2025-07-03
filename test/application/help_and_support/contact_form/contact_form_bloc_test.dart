import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/help_and_support/contact_form/contact_form_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/contact_message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/help_and_support/help_and_support_repository_interface.dart';

import 'contact_form_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HelpAndSupportRepositoryInterface>()])
void main() {
  late MockHelpAndSupportRepositoryInterface mockRepository;
  late ContactFormBloc contactFormBloc;

  const validMessageContent = 'This is a valid message.';
  const invalidMessageContent = '';
  const failure = Failure.serverError(errorString: 'error');
  final validMessage = getValidContactMessage();

  setUp(
    () {
      mockRepository = MockHelpAndSupportRepositoryInterface();
      contactFormBloc = ContactFormBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<ContactFormBloc, ContactFormState>(
        'emits a state with the changed message when MessageChanged is added',
        build: () => contactFormBloc,
        act: (bloc) => bloc.add(
          const ContactFormEvent.messageChanged(validMessageContent),
        ),
        expect: () => [
          contactFormBloc.state.copyWith(
            message: contactFormBloc.state.message.copyWith(
              content: MessageContent(validMessageContent),
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<ContactFormBloc, ContactFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(right(unit))] when message is '
        'valid and repository returns Right',
        setUp: () {
          when(
            mockRepository.submitContact(any),
          ).thenAnswer(
            (_) async => right(unit),
          );
        },
        seed: () => ContactFormState.initial().copyWith(
          message: validMessage,
        ),
        build: () => contactFormBloc,
        act: (bloc) => bloc.add(
          const ContactFormEvent.submitted(),
        ),
        expect: () => [
          contactFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          contactFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: false,
            failureOrSuccessOption: some(right(unit)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.submitContact(validMessage),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<ContactFormBloc, ContactFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(left(failure))] when message is '
        'valid and repository returns Left',
        setUp: () {
          when(mockRepository.submitContact(any)).thenAnswer(
            (_) async => left(failure),
          );
        },
        seed: () => ContactFormState.initial().copyWith(
          message: validMessage,
        ),
        build: () => contactFormBloc,
        act: (bloc) => bloc.add(
          const ContactFormEvent.submitted(),
        ),
        expect: () => [
          contactFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          contactFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: false,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.submitContact(validMessage),
        ).called(1),
      );

      blocTest<ContactFormBloc, ContactFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(left(Failure.emptyFields()))] '
        'when message is invalid',
        seed: () => ContactFormState.initial().copyWith(
          message: ContactMessage.empty().copyWith(
            content: MessageContent(invalidMessageContent),
          ),
        ),
        build: () => contactFormBloc,
        act: (bloc) => bloc.add(
          const ContactFormEvent.submitted(),
        ),
        expect: () => [
          contactFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          contactFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(
              left(const Failure.emptyFields()),
            ),
          ),
        ],
        verify: (_) => verifyNever(
          mockRepository.submitContact(any),
        ),
      );
    },
  );
}
