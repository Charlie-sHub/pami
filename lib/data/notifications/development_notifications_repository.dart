import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/notification.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/notifications/notifications_repository_interface.dart';

// coverage:ignore-files
/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: NotificationRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentNotificationRepository
    implements NotificationRepositoryInterface {
  /// Default constructor
  DevelopmentNotificationRepository(this._logger);

  final Logger _logger;

  @override
  Stream<Either<Failure, List<Notification>>> watchNotifications() {
    _logger.d('Watching notifications...');
    final notifications = [
      getValidNotification().copyWith(
        id: UniqueId(),
        description: EntityDescription('Notification 1'),
      ),
      getValidNotification().copyWith(
        id: UniqueId(),
        description: EntityDescription('Notification 2'),
        seen: false,
      ),
    ];

    _logger.d(
      'Returning mock notifications: ${notifications.map(
        (notification) => notification.id,
      )}',
    );
    return Stream.value(right(notifications));
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(UniqueId id) async {
    _logger.d('Marking notification as read: ${id.getOrCrash()}');
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(UniqueId id) async {
    _logger.d('Deleting notification: ${id.getOrCrash()}');
    return right(unit);
  }
}
