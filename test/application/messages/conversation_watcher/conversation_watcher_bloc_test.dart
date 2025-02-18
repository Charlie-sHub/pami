import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/messages/conversation_watcher/conversation_watcher_bloc.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/messages/messages_repository_interface.dart';

import 'conversation_watcher_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MessagesRepositoryInterface>()])
void main() {
  late MockMessagesRepositoryInterface mockRepository;
  late ConversationWatcherBloc conversationWatcherBloc;

  final validConversationId = UniqueId();
  final validMessages = <Message>[Message.empty()];
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockMessagesRepositoryInterface();
      conversationWatcherBloc = ConversationWatcherBloc(mockRepository);
    },
  );

  tearDown(
    () => conversationWatcherBloc.close(),
  );

  group(
    'Testing on success',
    () {
      blocTest<ConversationWatcherBloc, ConversationWatcherState>(
        'emits [loadInProgress, loadSuccess] when watchStarted '
        'is added and repository returns Right',
        setUp: () {
          when(mockRepository.watchMessages(any)).thenAnswer(
            (_) => Stream.value(right(validMessages)),
          );
        },
        build: () => conversationWatcherBloc,
        act: (bloc) => bloc.add(
          ConversationWatcherEvent.watchStarted(validConversationId),
        ),
        expect: () => [
          const ConversationWatcherState.loadInProgress(),
          ConversationWatcherState.loadSuccess(validMessages),
        ],
        verify: (_) => verify(
          mockRepository.watchMessages(validConversationId),
        ).called(1),
      );

      blocTest<ConversationWatcherBloc, ConversationWatcherState>(
        'emits [loadSuccess] when messagesReceived '
        'is added and result is Right',
        build: () => conversationWatcherBloc,
        act: (bloc) => bloc.add(
          ConversationWatcherEvent.messagesReceived(right(validMessages)),
        ),
        expect: () => [
          ConversationWatcherState.loadSuccess(validMessages),
        ],
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<ConversationWatcherBloc, ConversationWatcherState>(
        'emits [loadInProgress, loadFailure] when watchStarted '
        'is added and repository returns Left',
        setUp: () {
          when(mockRepository.watchMessages(any)).thenAnswer(
            (_) => Stream.value(left(failure)),
          );
        },
        build: () => conversationWatcherBloc,
        act: (bloc) => bloc.add(
          ConversationWatcherEvent.watchStarted(validConversationId),
        ),
        expect: () => [
          const ConversationWatcherState.loadInProgress(),
          const ConversationWatcherState.loadFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.watchMessages(validConversationId),
        ).called(1),
      );

      blocTest<ConversationWatcherBloc, ConversationWatcherState>(
        'emits [loadFailure] when messagesReceived is added and result is Left',
        build: () => conversationWatcherBloc,
        act: (bloc) => bloc.add(
          ConversationWatcherEvent.messagesReceived(left(failure)),
        ),
        expect: () => [
          const ConversationWatcherState.loadFailure(failure),
        ],
      );
    },
  );
}
