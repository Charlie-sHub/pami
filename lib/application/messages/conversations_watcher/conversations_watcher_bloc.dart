import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/messages/messages_repository_interface.dart';

part 'conversations_watcher_bloc.freezed.dart';
part 'conversations_watcher_event.dart';
part 'conversations_watcher_state.dart';

/// Conversations watcher bloc
@injectable
class ConversationsWatcherBloc
    extends Bloc<ConversationsWatcherEvent, ConversationsWatcherState> {
  /// Default constructor
  ConversationsWatcherBloc(this._repository)
      : super(const ConversationsWatcherState.initial()) {
    on<ConversationsWatcherEvent>(
      (event, emit) => event.when(
        watchStarted: (shoutOutId) async {
          emit(const ConversationsWatcherState.loadInProgress());
          await _streamSubscription?.cancel();
          _streamSubscription = _repository
              .watchConversations(
                shoutOutId,
              )
              .listen(
                (failureOrConversations) => add(
                  ConversationsWatcherEvent.conversationsReceived(
                    failureOrConversations,
                  ),
                ),
              );
          return null;
        },
        conversationsReceived: (result) => emit(
          result.fold(
            ConversationsWatcherState.loadFailure,
            ConversationsWatcherState.loadSuccess,
          ),
        ),
      ),
    );
  }

  final MessagesRepositoryInterface _repository;

  StreamSubscription<Either<Failure, List<Conversation>>>? _streamSubscription;

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
