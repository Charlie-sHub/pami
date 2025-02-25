import 'package:flutter_test/flutter_test.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/data/core/models/notification_dto.dart';

void main() {
  final notification = getValidNotification();
  final notificationDto = NotificationDto.fromDomain(notification);
  final json = notificationDto.toJson();

  group(
    'Testing on success',
    () {
      test(
        'fromDomain should return a valid DTO from a Notification entity',
        () {
          // act
          final result = NotificationDto.fromDomain(notification);
          // assert
          expect(result, equals(notificationDto));
        },
      );

      test(
        'toDomain should return a Notification entity from a valid DTO',
        () {
          // act
          final result = notificationDto.toDomain();
          // assert
          expect(result, equals(notification));
        },
      );

      test(
        'fromJson should return a valid DTO from a JSON map',
        () {
          // act
          final result = NotificationDto.fromJson(json);
          // assert
          expect(result, equals(notificationDto));
        },
      );

      test(
        'toJson should return a JSON map containing the proper data',
        () {
          // act
          final result = notificationDto.toJson();
          // assert
          expect(result, equals(json));
        },
      );
    },
  );
}
