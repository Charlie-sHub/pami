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
          const input = 'This is a valid notification content.';

          // Act
          final result = NotificationContent(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a NotificationContent with the input value '
        'when the input is at max length',
        () {
          // Arrange
          final input = 'a' * NotificationContent.maxLength;

          // Act
          final result = NotificationContent(input);

          // Assert
          expect(result.value, right(input));
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
          final input = 'a' * (NotificationContent.maxLength + 1);

          // Act
          final result = NotificationContent(input);

          // Assert
          expect(
            result.value,
            left(
              Failure<String>.stringExceedsLength(
                failedValue: input,
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
          const input = '';

          // Act
          final result = NotificationContent(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.emptyString(failedValue: input),
            ),
          );
        },
      );

      test(
        'should return a Failure.multiLineString '
        'when the input contains multiple lines',
        () {
          // Arrange
          const input = 'Notification\nContent';

          // Act
          final result = NotificationContent(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.multiLineString(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
