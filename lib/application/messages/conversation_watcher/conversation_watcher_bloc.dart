import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/messages/messages_repository_interface.dart';

part 'conversation_watcher_bloc.freezed.dart';
part 'conversation_watcher_event.dart';
part 'conversation_watcher_state.dart';

/// Conversation watcher bloc
@injectable
class ConversationWatcherBloc
    extends Bloc<ConversationWatcherEvent, ConversationWatcherState> {
  /// Default constructor
  ConversationWatcherBloc(
    this._repository,
  ) : super(const ConversationWatcherState.initial()) {
    on<ConversationWatcherEvent>(
      (event, emit) => event.when(
        watchStarted: (conversationId) async {
          emit(const ConversationWatcherState.loadInProgress());
          await _streamSubscription?.cancel();
          _streamSubscription = _repository
              .watchMessages(
                conversationId,
              )
              .listen(
                (failureOrMessages) => add(
                  ConversationWatcherEvent.messagesReceived(
                    failureOrMessages,
                  ),
                ),
              );
          return null;
        },
        messagesReceived: (result) => emit(
          result.fold(
            ConversationWatcherState.loadFailure,
            ConversationWatcherState.loadSuccess,
          ),
        ),
      ),
    );
  }

  final MessagesRepositoryInterface _repository;

  StreamSubscription<Either<Failure, List<Message>>>? _streamSubscription;

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
