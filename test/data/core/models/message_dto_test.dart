import 'package:flutter_test/flutter_test.dart';
import 'package:pami/data/core/models/message_dto.dart';

import '../../../misc/get_valid_message.dart';

void main() {
  final message = getValidMessage();
  final messageDto = MessageDto.fromDomain(message);
  final json = messageDto.toJson();

  group(
    'Testing on success',
    () {
      test(
        'fromDomain should return a valid DTO from a Message entity',
        () {
          // act
          final result = MessageDto.fromDomain(message);
          // assert
          expect(result, equals(messageDto));
        },
      );

      test(
        'toDomain should return a Message entity from a valid DTO',
        () {
          // act
          final result = messageDto.toDomain();
          // assert
          expect(result, equals(message));
        },
      );

      test(
        'fromJson should return a valid DTO from a JSON map',
        () {
          // act
          final result = MessageDto.fromJson(json);
          // assert
          expect(result, equals(messageDto));
        },
      );

      test(
        'toJson should return a JSON map containing the proper data',
        () {
          // act
          final result = messageDto.toJson();
          // assert
          expect(result, equals(json));
        },
      );
    },
  );
}
