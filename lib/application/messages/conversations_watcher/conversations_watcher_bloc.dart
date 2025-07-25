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
  ConversationsWatcherBloc(
    this._repository,
  ) : super(const ConversationsWatcherState.initial()) {
    on<_WatchStarted>(_onWatchStarted);
    on<_ResultsReceived>(_onResultsReceived);
  }

  final MessagesRepositoryInterface _repository;

  StreamSubscription<Either<Failure, List<Conversation>>>? _streamSubscription;

  Future<void> _onWatchStarted(_WatchStarted event, Emitter emit) async {
    emit(const ConversationsWatcherState.loadInProgress());
    await _streamSubscription?.cancel();
    _streamSubscription = _repository
        .watchConversations(
          event.shoutOutId,
        )
        .listen(
          (failureOrConversations) => add(
            ConversationsWatcherEvent.resultsReceived(
              failureOrConversations,
            ),
          ),
        );
  }

  void _onResultsReceived(_ResultsReceived event, Emitter emit) => emit(
    event.result.fold(
      ConversationsWatcherState.loadFailure,
      ConversationsWatcherState.loadSuccess,
    ),
  );

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
