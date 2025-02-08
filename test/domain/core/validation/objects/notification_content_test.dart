import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/notification_content.dart';

void main() {
  group(
    'Testing on success',
    () {
      const validNotificationContent = 'This is a valid notification content.';
      final maxLengthNotificationContent = 'a' * NotificationContent.maxLength;
      final validNotificationContentObject = NotificationContent(
        validNotificationContent,
      );
      final maxLengthNotificationContentObject = NotificationContent(
        maxLengthNotificationContent,
      );

      test(
        'should return a NotificationContent with the input value '
        'when the input is valid',
        () {
          // Assert
          expect(
            validNotificationContentObject.value,
            right(validNotificationContent),
          );
        },
      );

      test(
        'should return a NotificationContent with the input value '
        'when the input is at max length',
        () {
          // Assert
          expect(
            maxLengthNotificationContentObject.value,
            right(maxLengthNotificationContent),
          );
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      final overMaxLengthNotificationContent =
          'a' * (NotificationContent.maxLength + 1);
      const emptyNotificationContent = '';
      const multiLineNotificationContent = 'Notification\nContent';

      final overMaxLengthNotificationContentObject = NotificationContent(
        overMaxLengthNotificationContent,
      );
      final emptyNotificationContentObject = NotificationContent(
        emptyNotificationContent,
      );
      final multiLineNotificationContentObject = NotificationContent(
        multiLineNotificationContent,
      );

      test(
        'should return a Failure.stringExceedsLength '
        'when the input exceeds the max length',
        () {
          // Assert
          expect(
            overMaxLengthNotificationContentObject.value,
            left(
              Failure<String>.stringExceedsLength(
                failedValue: overMaxLengthNotificationContent,
                maxLength: NotificationContent.maxLength,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.emptyString when the input is empty',
        () {
          // Assert
          expect(
            emptyNotificationContentObject.value,
            left(
              const Failure<String>.emptyString(
                failedValue: emptyNotificationContent,
              ),
            ),
          );
        },
      );

      test(
        'should return a Failure.multiLineString '
        'when the input contains multiple lines',
        () {
          // Assert
          expect(
            multiLineNotificationContentObject.value,
            left(
              const Failure<String>.multiLineString(
                failedValue: multiLineNotificationContent,
              ),
            ),
          );
        },
      );
    },
  );
}
