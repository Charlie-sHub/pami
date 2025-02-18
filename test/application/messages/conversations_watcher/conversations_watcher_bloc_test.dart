import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/messages/conversations_watcher/conversations_watcher_bloc.dart';
import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/messages/messages_repository_interface.dart';

import 'conversations_watcher_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MessagesRepositoryInterface>()])
void main() {
  late MockMessagesRepositoryInterface mockRepository;
  late ConversationsWatcherBloc conversationsWatcherBloc;

  final validShoutOutId = UniqueId();
  final validConversations = <Conversation>[Conversation.empty()];
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockMessagesRepositoryInterface();
      conversationsWatcherBloc = ConversationsWatcherBloc(mockRepository);
    },
  );

  tearDown(
    () => conversationsWatcherBloc.close(),
  );

  group(
    'Testing on success',
    () {
      blocTest<ConversationsWatcherBloc, ConversationsWatcherState>(
        'emits [loadInProgress, loadSuccess] when watchStarted '
        'is added and repository returns Right',
        setUp: () {
          when(mockRepository.watchConversations(any)).thenAnswer(
            (_) => Stream.value(
              right(validConversations),
            ),
          );
        },
        build: () => conversationsWatcherBloc,
        act: (bloc) => bloc.add(
          ConversationsWatcherEvent.watchStarted(validShoutOutId),
        ),
        expect: () => [
          const ConversationsWatcherState.loadInProgress(),
          ConversationsWatcherState.loadSuccess(validConversations),
        ],
        verify: (_) => verify(
          mockRepository.watchConversations(validShoutOutId),
        ).called(1),
      );

      blocTest<ConversationsWatcherBloc, ConversationsWatcherState>(
        'emits [loadSuccess] when conversationsReceived '
        'is added and result is Right',
        build: () => conversationsWatcherBloc,
        act: (bloc) => bloc.add(
          ConversationsWatcherEvent.conversationsReceived(
            right(validConversations),
          ),
        ),
        expect: () => [
          ConversationsWatcherState.loadSuccess(validConversations),
        ],
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<ConversationsWatcherBloc, ConversationsWatcherState>(
        'emits [loadInProgress, loadFailure] when watchStarted '
        'is added and repository returns Left',
        setUp: () {
          when(mockRepository.watchConversations(any)).thenAnswer(
            (_) => Stream.value(
              left(failure),
            ),
          );
        },
        build: () => conversationsWatcherBloc,
        act: (bloc) => bloc.add(
          ConversationsWatcherEvent.watchStarted(validShoutOutId),
        ),
        expect: () => [
          const ConversationsWatcherState.loadInProgress(),
          const ConversationsWatcherState.loadFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.watchConversations(validShoutOutId),
        ).called(1),
      );

      blocTest<ConversationsWatcherBloc, ConversationsWatcherState>(
        'emits [loadFailure] when conversationsReceived '
        'is added and result is Left',
        build: () => conversationsWatcherBloc,
        act: (bloc) => bloc.add(
          ConversationsWatcherEvent.conversationsReceived(left(failure)),
        ),
        expect: () => [
          const ConversationsWatcherState.loadFailure(failure),
        ],
      );
    },
  );
}
