import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/notifications/notification_actor/notification_actor_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/notifications/notifications_repository_interface.dart';

import 'notification_actor_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NotificationRepositoryInterface>()])
void main() {
  late MockNotificationRepositoryInterface mockRepository;
  late NotificationActorBloc notificationActorBloc;

  final validNotificationId = UniqueId();
  const failure = Failure.serverError(errorString: 'error');

  setUp(
    () {
      mockRepository = MockNotificationRepositoryInterface();
      notificationActorBloc = NotificationActorBloc(mockRepository);
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<NotificationActorBloc, NotificationActorState>(
        'emits [readMarkSuccess] when markAsRead is added and '
        'repository returns Right',
        setUp: () {
          when(mockRepository.markAsRead(any)).thenAnswer(
            (_) async => right(unit),
          );
        },
        build: () => notificationActorBloc,
        act: (bloc) => bloc.add(
          NotificationActorEvent.markAsRead(validNotificationId),
        ),
        expect: () => [
          const NotificationActorState.readMarkSuccess(),
        ],
        verify: (_) => verify(
          mockRepository.markAsRead(validNotificationId),
        ).called(1),
      );

      blocTest<NotificationActorBloc, NotificationActorState>(
        'emits [actionInProgress, deletionSuccess] when '
        'deleteNotification is added and repository returns Right',
        setUp: () {
          when(mockRepository.deleteNotification(any)).thenAnswer(
            (_) async => right(unit),
          );
        },
        build: () => notificationActorBloc,
        act: (bloc) => bloc.add(
          NotificationActorEvent.deleteNotification(validNotificationId),
        ),
        expect: () => [
          const NotificationActorState.actionInProgress(),
          const NotificationActorState.deletionSuccess(),
        ],
        verify: (_) => verify(
          mockRepository.deleteNotification(validNotificationId),
        ).called(1),
      );
    },
  );

  group(
    'Testing on failure',
    () {
      blocTest<NotificationActorBloc, NotificationActorState>(
        'emits no new state when markAsRead is added and '
        'repository returns Left',
        setUp: () {
          when(mockRepository.markAsRead(any)).thenAnswer(
            (_) async => left(failure),
          );
        },
        build: () => notificationActorBloc,
        act: (bloc) => bloc.add(
          NotificationActorEvent.markAsRead(validNotificationId),
        ),
        expect: () => [const NotificationActorState.initial()],
        verify: (_) => verify(
          mockRepository.markAsRead(validNotificationId),
        ).called(1),
      );

      blocTest<NotificationActorBloc, NotificationActorState>(
        'emits [actionInProgress, deletionFailure] when '
        'deleteNotification is added and repository returns Left',
        setUp: () {
          when(mockRepository.deleteNotification(any)).thenAnswer(
            (_) async => left(failure),
          );
        },
        build: () => notificationActorBloc,
        act: (bloc) => bloc.add(
          NotificationActorEvent.deleteNotification(validNotificationId),
        ),
        expect: () => [
          const NotificationActorState.actionInProgress(),
          const NotificationActorState.deletionFailure(failure),
        ],
        verify: (_) => verify(
          mockRepository.deleteNotification(validNotificationId),
        ).called(1),
      );
    },
  );
}
