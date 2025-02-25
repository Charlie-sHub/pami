import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

void main() {
  final validConversation = getValidConversation();
  final invalidLastMessageConversation = validConversation.copyWith(
    lastMessage: MessageContent(''),
  );
  final invalidDateCreatedConversation = validConversation.copyWith(
    dateCreated: PastDate(
      DateTime.now().add(
        const Duration(days: 10),
      ),
    ),
  );
  final invalidLastMessageAndDateCreatedConversation =
      validConversation.copyWith(
    lastMessage: MessageContent(''),
    dateCreated: PastDate(
      DateTime.now().add(
        const Duration(days: 10),
      ),
    ),
  );

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () {
          // Assert
          expect(validConversation.isValid, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () {
          // Assert
          expect(validConversation.failureOption, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Assert
          expect(validConversation.failureOrUnit, right(unit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidLastMessageConversation',
        () {
          // Assert
          expect(invalidLastMessageConversation.isValid, false);
        },
      );

      test(
        'should be invalid with invalidDateCreatedConversation',
        () {
          // Assert
          expect(invalidDateCreatedConversation.isValid, false);
        },
      );

      test(
        'should be invalid with invalidLastMessageAndDateCreatedConversation',
        () {
          // Assert
          expect(invalidLastMessageAndDateCreatedConversation.isValid, false);
        },
      );

      test(
        'should return some when lastMessage is invalid',
        () {
          // Assert
          expect(
            invalidLastMessageConversation.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () {
          // Assert
          expect(
            invalidDateCreatedConversation.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return left(Failure) when lastMessage is invalid',
        () {
          // Act
          final result = invalidLastMessageConversation.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left(Failure) when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedConversation.failureOrUnit;

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
        'should return a Conversation with default values',
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
}
