import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/messages/message_form/message_form_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/messages/messages_repository_interface.dart';

import 'message_form_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MessagesRepositoryInterface>()])
void main() {
  late MockMessagesRepositoryInterface mockRepository;
  late MessageFormBloc messageFormBloc;

  const validMessageContent = 'This is a valid message.';
  const invalidMessageContent = '';
  const failure = Failure.serverError(errorString: 'error');
  final validMessage = getValidMessage();

  setUp(
    () {
      mockRepository = MockMessagesRepositoryInterface();
      messageFormBloc = MessageFormBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<MessageFormBloc, MessageFormState>(
        'emits a state with the changed message when MessageChanged is added',
        build: () => messageFormBloc,
        act: (bloc) => bloc.add(
          const MessageFormEvent.messageChanged(validMessageContent),
        ),
        expect: () => [
          messageFormBloc.state.copyWith(
            message: messageFormBloc.state.message.copyWith(
              content: MessageContent(validMessageContent),
            ),
            failureOrSuccessOption: none(),
          ),
        ],
      );

      blocTest<MessageFormBloc, MessageFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(right(unit))] when message '
        'is valid and repository returns Right',
        setUp: () {
          when(
            mockRepository.sendMessage(any),
          ).thenAnswer(
            (_) async => right(unit),
          );
        },
        seed: () => MessageFormState.initial().copyWith(
          message: validMessage,
        ),
        build: () => messageFormBloc,
        act: (bloc) => bloc.add(
          const MessageFormEvent.submitted(),
        ),
        expect: () => [
          messageFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          messageFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(right(unit)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.sendMessage(validMessage),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<MessageFormBloc, MessageFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(left(failure))] when message '
        'is valid and repository returns Left',
        setUp: () {
          when(mockRepository.sendMessage(any)).thenAnswer(
            (_) async => left(failure),
          );
        },
        seed: () => MessageFormState.initial().copyWith(
          message: validMessage,
        ),
        build: () => messageFormBloc,
        act: (bloc) => bloc.add(
          const MessageFormEvent.submitted(),
        ),
        expect: () => [
          messageFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          messageFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(left(failure)),
          ),
        ],
        verify: (_) => verify(
          mockRepository.sendMessage(validMessage),
        ).called(1),
      );

      blocTest<MessageFormBloc, MessageFormState>(
        'emits [isSubmitting: true, failureOrSuccessOption: none], '
        '[isSubmitting: false, showErrorMessages: true, '
        'failureOrSuccessOption: some(left(Failure.emptyFields()))] '
        'when message is invalid',
        seed: () => MessageFormState.initial().copyWith(
          message: Message.empty().copyWith(
            content: MessageContent(invalidMessageContent),
          ),
        ),
        build: () => messageFormBloc,
        act: (bloc) => bloc.add(
          const MessageFormEvent.submitted(),
        ),
        expect: () => [
          messageFormBloc.state.copyWith(
            isSubmitting: true,
            showErrorMessages: false,
            failureOrSuccessOption: none(),
          ),
          messageFormBloc.state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            failureOrSuccessOption: some(
              left(const Failure.emptyFields()),
            ),
          ),
        ],
        verify: (_) => verifyNever(
          mockRepository.sendMessage(any),
        ),
      );
    },
  );
}
