import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';

void main() {
  group(
    'Testing on success',
    () {
      const validMessageContent = 'This is a valid message content.';
      final maxLengthMessageContent = 'a' * MessageContent.maxLength;
      final validMessageContentObject = MessageContent(validMessageContent);
      final maxLengthMessageContentObject = MessageContent(
        maxLengthMessageContent,
      );

      test(
        'should return a MessageContent with the input value '
        'when the input is valid',
        () {
          // Assert
          expect(validMessageContentObject.value, right(validMessageContent));
        },
      );

      test(
        'should return a MessageContent with the input value '
        'when the input is at max length',
        () {
          // Assert
          expect(
            maxLengthMessageContentObject.value,
            right(maxLengthMessageContent),
          );
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      final overMaxLengthMessageContent = 'a' * (MessageContent.maxLength + 1);
      const emptyMessageContent = '';
      final overMaxLengthMessageContentObject = MessageContent(
        overMaxLengthMessageContent,
      );
      final emptyMessageContentObject = MessageContent(emptyMessageContent);

      test(
        'should return a Failure.stringExceedsLength '
        'when the input exceeds the max length',
        () {
          // Assert
          expect(
            overMaxLengthMessageContentObject.value,
            left(
              Failure<String>.stringExceedsLength(
                failedValue: overMaxLengthMessageContent,
                maxLength: MessageContent.maxLength,
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
            emptyMessageContentObject.value,
            left(
              const Failure<String>.emptyString(
                failedValue: emptyMessageContent,
              ),
            ),
          );
        },
      );
    },
  );
}
