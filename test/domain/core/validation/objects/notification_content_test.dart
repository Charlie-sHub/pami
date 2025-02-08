import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/notification_content.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a NotificationContent with the input value '
        'when the input is valid',
        () {
          // Arrange
          const validNotificationContent =
              'This is a valid notification content.';
          final validNotificationContentObject = NotificationContent(
            validNotificationContent,
          );

          // Act
          final result = validNotificationContentObject.value;

          // Assert
          expect(result, right(validNotificationContent));
        },
      );

      test(
        'should return a NotificationContent with the input value '
        'when the input is at max length',
        () {
          // Arrange
          final maxLengthNotificationContent =
              'a' * NotificationContent.maxLength;
          final maxLengthNotificationContentObject = NotificationContent(
            maxLengthNotificationContent,
          );

          // Act
          final result = maxLengthNotificationContentObject.value;

          // Assert
          expect(result, right(maxLengthNotificationContent));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should return a Failure.stringExceedsLength '
        'when the input exceeds the max length',
        () {
          // Arrange
          final overMaxLengthNotificationContent =
              'a' * (NotificationContent.maxLength + 1);
          final overMaxLengthNotificationContentObject = NotificationContent(
            overMaxLengthNotificationContent,
          );

          // Act
          final result = overMaxLengthNotificationContentObject.value;

          // Assert
          expect(
            result,
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
          // Arrange
          const emptyNotificationContent = '';
          final emptyNotificationContentObject = NotificationContent(
            emptyNotificationContent,
          );

          // Act
          final result = emptyNotificationContentObject.value;

          // Assert
          expect(
            result,
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
          // Arrange
          const multiLineNotificationContent = 'Notification\nContent';
          final multiLineNotificationContentObject = NotificationContent(
            multiLineNotificationContent,
          );

          // Act
          final result = multiLineNotificationContentObject.value;

          // Assert
          expect(
            result,
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
