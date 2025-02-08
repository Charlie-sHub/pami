import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';

import '../../../misc/get_valid_conversation.dart';

void main() {
  final validConversation = getValidConversation();
  final invalidLastMessageConversation = validConversation.copyWith(
    lastMessage: MessageContent(''),
  );
  final invalidDateCreatedConversation = validConversation.copyWith(
    dateCreated: PastDate(
      DateTime.now().add(const Duration(days: 10)),
    ),
  );
  final invalidLastMessageAndDateCreatedConversation =
      validConversation.copyWith(
    lastMessage: MessageContent(''),
    dateCreated: PastDate(
      DateTime.now().add(const Duration(days: 10)),
    ),
  );

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () async {
          // Assert
          expect(validConversation.isValid, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () async {
          // Assert
          expect(validConversation.failureOption, none());
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidLastMessageConversation',
        () async {
          // Assert
          expect(invalidLastMessageConversation.isValid, false);
        },
      );

      test(
        'should be invalid with invalidDateCreatedConversation',
        () async {
          // Assert
          expect(invalidDateCreatedConversation.isValid, false);
        },
      );

      test(
        'should be invalid with invalidLastMessageAndDateCreatedConversation',
        () async {
          // Assert
          expect(invalidLastMessageAndDateCreatedConversation.isValid, false);
        },
      );

      test(
        'should return some when lastMessage is invalid',
        () async {
          // Assert
          expect(
            invalidLastMessageConversation.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () async {
          // Assert
          expect(
            invalidDateCreatedConversation.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when lastMessage and dateCreated are invalid',
        () async {
          // Assert
          expect(
            invalidLastMessageAndDateCreatedConversation.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );
    },
  );
}
