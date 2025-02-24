import 'package:flutter_test/flutter_test.dart';
import 'package:pami/data/core/models/conversation_dto.dart';

import '../../../misc/get_valid_conversation.dart';

void main() {
  final conversation = getValidConversation();
  final conversationDto = ConversationDto.fromDomain(
    conversation,
  );
  final json = conversationDto.toJson();

  group(
    'Testing on success',
    () {
      test(
        'fromDomain should return a valid DTO from a Conversation entity',
        () {
          // act
          final result = ConversationDto.fromDomain(conversation);
          // assert
          expect(result, equals(conversationDto));
        },
      );

      test(
        'toDomain should return a Conversation entity from a valid DTO',
        () {
          // act
          final result = conversationDto.toDomain();
          // assert
          expect(result, equals(conversation));
        },
      );

      test(
        'fromJson should return a valid DTO from a JSON map',
        () {
          // act
          final result = ConversationDto.fromJson(json);
          // assert
          expect(result, equals(conversationDto));
        },
      );

      test(
        'toJson should return a JSON map containing the proper data',
        () {
          // act
          final result = conversationDto.toJson();
          // assert
          expect(result, equals(json));
        },
      );
    },
  );
}
