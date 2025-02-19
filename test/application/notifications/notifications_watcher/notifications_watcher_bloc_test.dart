import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/notifications/notifications_watcher/notifications_watcher_bloc.dart';
import 'package:pami/domain/core/entities/notification.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/notifications/notifications_repository_interface.dart';

import 'notifications_watcher_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NotificationRepositoryInterface>()])
void main() {
  late MockNotificationRepositoryInterface mockRepository;
  late NotificationsWatcherBloc notificationsWatcherBloc;

  final validNotifications = <Notification>[Notification.empty()];
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockNotificationRepositoryInterface();
      notificationsWatcherBloc = NotificationsWatcherBloc(mockRepository);
    },
  );

  tearDown(
    () => notificationsWatcherBloc.close(),
  );

  group(
    'Testing on success',
    () {
      blocTest<NotificationsWatcherBloc, NotificationsWatcherState>(
        'emits [loadInProgress, loadSuccess] when watchStarted is '
        'added and repository returns Right',
        setUp: () {
          when(mockRepository.watchNotifications()).thenAnswer(
            (_) => Stream.value(
              right(validNotifications),
            ),
          );
        },
        build: () => notificationsWatcherBloc,
        act: (bloc) => bloc.add(
          const NotificationsWatcherEvent.watchStarted(),
        ),
        expect: () => [
          const NotificationsWatcherState.loadInProgress(),
          NotificationsWatcherState.loadSuccess(validNotifications),
        ],
        verify: (_) => verify(
          mockRepository.watchNotifications(),
        ).called(1),
      );

      blocTest<NotificationsWatcherBloc, NotificationsWatcherState>(
        'emits [loadSuccess] when notificationsReceived is '
        'added and result is Right',
        build: () => notificationsWatcherBloc,
        act: (bloc) => bloc.add(
          NotificationsWatcherEvent.notificationsReceived(
            right(validNotifications),
          ),
        ),
        expect: () => [
          NotificationsWatcherState.loadSuccess(validNotifications),
        ],
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<NotificationsWatcherBloc, NotificationsWatcherState>(
        'emits [loadInProgress, loadFailure] when watchStarted is '
        'added and repository returns Left',
        setUp: () {
          when(mockRepository.watchNotifications()).thenAnswer(
            (_) => Stream.value(
              left(failure),
            ),
          );
        },
        build: () => notificationsWatcherBloc,
        act: (bloc) => bloc.add(
          const NotificationsWatcherEvent.watchStarted(),
        ),
        expect: () => [
          const NotificationsWatcherState.loadInProgress(),
          const NotificationsWatcherState.loadFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.watchNotifications(),
        ).called(1),
      );

      blocTest<NotificationsWatcherBloc, NotificationsWatcherState>(
        'emits [loadFailure] when notificationsReceived is '
        'added and result is Left',
        build: () => notificationsWatcherBloc,
        act: (bloc) => bloc.add(
          NotificationsWatcherEvent.notificationsReceived(left(failure)),
        ),
        expect: () => [
          const NotificationsWatcherState.loadFailure(failure),
        ],
      );
    },
  );
}
