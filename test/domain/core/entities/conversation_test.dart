import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

void main() {
  final validId = UniqueId();
  final validShoutOutCreatorId = UniqueId();
  final validInterestedId = UniqueId();
  final validLastMessage = MessageContent('Hello');
  final validLastMessageDate = DateTime.now().subtract(
    const Duration(days: 1),
  );
  final validDateCreated = PastDate(
    DateTime.now().subtract(
      const Duration(days: 2),
    ),
  );

  group(
    'Constructor',
    () {
      test(
        'should create a valid Conversation when all inputs are valid',
        () {
          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: validLastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: validDateCreated,
          );

          // Assert
          expect(conversation.id, validId);
          expect(conversation.shoutOutCreatorId, validShoutOutCreatorId);
          expect(conversation.interestedId, validInterestedId);
          expect(conversation.lastMessage, validLastMessage);
          expect(conversation.lastMessageDate, validLastMessageDate);
          expect(conversation.dateCreated, validDateCreated);
          expect(conversation.isValid, true);
          expect(conversation.failureOption, none());
          expect(conversation.failureOrUnit, right(unit));
        },
      );

      test(
        'should not create a valid Conversation when lastMessage is invalid',
        () {
          // Arrange
          final lastMessage = MessageContent(
            'a' * (MessageContent.maxLength + 1),
          );

          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: lastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: validDateCreated,
          );

          print(conversation.isValid);

          // Assert
          expect(conversation.isValid, false);
          expect(conversation.failureOption, isA<Some<Failure<dynamic>>>());
          expect(
            conversation.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should not create a valid Conversation when dateCreated is invalid',
        () {
          // Arrange
          final dateCreated = PastDate(
            DateTime.now().add(const Duration(days: 2)),
          );

          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: validLastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: dateCreated,
          );

          // Assert
          expect(conversation.isValid, false);
          expect(conversation.failureOption, isA<Some<Failure<dynamic>>>());
          expect(
            conversation.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );
    },
  );

  group(
    'Empty Constructor',
    () {
      test(
        'should create an empty Conversation with default values',
        () {
          // Act
          final conversation = Conversation.empty();

          // Assert
          expect(conversation.id, isA<UniqueId>());
          expect(conversation.shoutOutCreatorId, isA<UniqueId>());
          expect(conversation.interestedId, isA<UniqueId>());
          expect(conversation.lastMessage, isA<MessageContent>());
          expect(conversation.lastMessageDate, isA<DateTime>());
          expect(conversation.dateCreated, isA<PastDate>());
        },
      );
    },
  );

  group(
    'failureOrUnit',
    () {
      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: validLastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: validDateCreated,
          );

          // Assert
          expect(conversation.failureOrUnit, right(unit));
        },
      );

      test(
        'should return left when lastMessage is invalid',
        () {
          // Arrange
          final lastMessage = MessageContent(
            'a' * (MessageContent.maxLength + 1),
          );

          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: lastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: validDateCreated,
          );

          // Assert
          expect(
            conversation.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () {
          // Arrange
          final dateCreated = PastDate(
            DateTime.now().add(const Duration(days: 2)),
          );

          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: validLastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: dateCreated,
          );

          // Assert
          expect(
            conversation.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );
    },
  );

  group(
    'isValid',
    () {
      test(
        'should return true when all inputs are valid',
        () {
          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: validLastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: validDateCreated,
          );

          // Assert
          expect(conversation.isValid, true);
        },
      );

      test(
        'should return false when lastMessage is invalid',
        () {
          // Arrange
          final lastMessage = MessageContent('');

          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: lastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: validDateCreated,
          );

          // Assert
          expect(conversation.isValid, false);
        },
      );

      test(
        'should return false when dateCreated is invalid',
        () {
          // Arrange
          final dateCreated =
              PastDate(DateTime.now().add(const Duration(days: 2)));

          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: validLastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: dateCreated,
          );

          // Assert
          expect(conversation.isValid, false);
        },
      );
    },
  );

  group(
    'failureOption',
    () {
      test(
        'should return none when all inputs are valid',
        () {
          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: validLastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: validDateCreated,
          );

          // Assert
          expect(conversation.failureOption, none());
        },
      );

      test(
        'should return some when lastMessage is invalid',
        () {
          // Arrange
          final lastMessage = MessageContent('');

          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: lastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: validDateCreated,
          );

          // Assert
          expect(conversation.failureOption, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () {
          // Arrange
          final dateCreated = PastDate(
            DateTime.now().add(const Duration(days: 2)),
          );

          // Act
          final conversation = Conversation(
            id: validId,
            shoutOutCreatorId: validShoutOutCreatorId,
            interestedId: validInterestedId,
            lastMessage: validLastMessage,
            lastMessageDate: validLastMessageDate,
            dateCreated: dateCreated,
          );

          // Assert
          expect(conversation.failureOption, isA<Some<Failure<dynamic>>>());
        },
      );
    },
  );
}
