import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/notification.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the notification repository
abstract class NotificationRepositoryInterface {
  /// Fetches the notifications of the current user
  Future<Either<Failure, List<Notification>>> fetchNotifications();

  /// Marks a notification as read
  Future<Either<Failure, Unit>> markAsRead(UniqueId id);

  /// Deletes a notification
  Future<Either<Failure, Unit>> deleteNotification(UniqueId id);
}
