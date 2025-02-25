import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

void main() {
  final validMessage = getValidMessage();
  final invalidContentMessage = validMessage.copyWith(
    content: MessageContent(''),
  );
  final invalidDateCreatedMessage = validMessage.copyWith(
    dateCreated: PastDate(
      DateTime.now().add(const Duration(days: 10)),
    ),
  );

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () {
          // Act
          final result = validMessage.isValid;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () {
          // Act
          final result = validMessage.failureOption;

          // Assert
          expect(result, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Act
          final result = validMessage.failureOrUnit;

          // Assert
          expect(result, right(unit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidContentMessage',
        () {
          // Act
          final result = invalidContentMessage.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidDateCreatedMessage',
        () {
          // Act
          final result = invalidDateCreatedMessage.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return some when content is invalid',
        () {
          // Act
          final result = invalidContentMessage.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedMessage.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return left when content is invalid',
        () {
          // Act
          final result = invalidContentMessage.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedMessage.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );
    },
  );

  group(
    'empty',
    () {
      test(
        'should return a Message with default values',
        () {
          // Act
          final message = Message.empty();

          // Assert
          expect(message.id, isA<UniqueId>());
          expect(message.senderId, isA<UniqueId>());
          expect(message.content, isA<MessageContent>());
          expect(message.isRead, false);
          expect(message.dateCreated, isA<PastDate>());
        },
      );
    },
  );
}
