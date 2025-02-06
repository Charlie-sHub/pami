import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
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
          const input = 'This is a valid message content.';

          // Act
          final result = MessageContent(input);

          // Assert
          expect(result.value, right(input));
        },
      );

      test(
        'should return a MessageContent with the input value '
        'when the input is at max length',
        () {
          // Arrange
          final input = 'a' * MessageContent.maxLength;

          // Act
          final result = MessageContent(input);

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
          final input = 'a' * (MessageContent.maxLength + 1);

          // Act
          final result = MessageContent(input);

          // Assert
          expect(
            result.value,
            left(
              Failure<String>.stringExceedsLength(
                failedValue: input,
                maxLength: MessageContent.maxLength,
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
          final result = MessageContent(input);

          // Assert
          expect(
            result.value,
            left(
              const Failure<String>.emptyString(failedValue: input),
            ),
          );
        },
      );
    },
  );
}
