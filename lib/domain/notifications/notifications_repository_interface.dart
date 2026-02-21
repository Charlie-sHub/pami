import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/notification.dart';
import 'package:pami/domain/core/failures/app_failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the notification repository
abstract class NotificationRepositoryInterface {
  /// Fetches the notifications of the current user
  Stream<Either<AppFailure, List<Notification>>> watchNotifications();

  /// Marks a notification as read
  Future<Either<AppFailure, Unit>> markAsRead(UniqueId id);

  /// Deletes a notification
  Future<Either<AppFailure, Unit>> deleteNotification(UniqueId id);
}
