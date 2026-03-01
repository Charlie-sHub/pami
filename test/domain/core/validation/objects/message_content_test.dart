import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/value_failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';

void main() {
  group(
    'Testing on success',
    () {
      test(
        'should return a MessageContent with the input value '
        'when the input is valid',
        () {
          // Arrange
          const validMessageContent = 'This is a valid message content.';
          final validMessageContentObject = MessageContent(validMessageContent);

          // Act
          final result = validMessageContentObject.value;

          // Assert
          expect(
            result,
            right<ValueFailure<String>, String>(validMessageContent),
          );
        },
      );

      test(
        'should return a MessageContent with the input value '
        'when the input is at max length',
        () {
          // Arrange
          final maxLengthMessageContent = 'a' * MessageContent.maxLength;
          final maxLengthMessageContentObject = MessageContent(
            maxLengthMessageContent,
          );

          // Act
          final result = maxLengthMessageContentObject.value;

          // Assert
          expect(
            result,
            right<ValueFailure<String>, String>(maxLengthMessageContent),
          );
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
          final overMaxLengthMessageContent =
              'a' * (MessageContent.maxLength + 1);
          final overMaxLengthMessageContentObject = MessageContent(
            overMaxLengthMessageContent,
          );

          // Act
          final result = overMaxLengthMessageContentObject.value;

          // Assert
          expect(
            result,
            left<ValueFailure<String>, String>(
              ValueFailure<String>.stringExceedsLength(
                failedValue: overMaxLengthMessageContent,
                maxLength: MessageContent.maxLength,
              ),
            ),
          );
        },
      );

      test(
        'should return a ValueFailure.emptyString when the input is empty',
        () {
          // Arrange
          const emptyMessageContent = '';
          final emptyMessageContentObject = MessageContent(
            emptyMessageContent,
          );

          // Act
          final result = emptyMessageContentObject.value;

          // Assert
          expect(
            result,
            left<ValueFailure<String>, String>(
              const ValueFailure<String>.emptyString(
                failedValue: emptyMessageContent,
              ),
            ),
          );
        },
      );
    },
  );
}
