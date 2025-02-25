import 'package:flutter_test/flutter_test.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/data/core/models/contact_message_dto.dart';

void main() {
  final contactMessage = getValidContactMessage();
  final contactMessageDto = ContactMessageDto.fromDomain(
    contactMessage,
  );
  final json = contactMessageDto.toJson();

  group(
    'Testing on success',
    () {
      test(
        'fromDomain should return a valid DTO from a ContactMessage entity',
        () {
          // act
          final result = ContactMessageDto.fromDomain(contactMessage);
          // assert
          expect(result, equals(contactMessageDto));
        },
      );

      test(
        'toDomain should return a ContactMessage entity from a valid DTO',
        () {
          // act
          final result = contactMessageDto.toDomain();
          // assert
          expect(result, equals(contactMessage));
        },
      );

      test(
        'fromJson should return a valid DTO from a JSON map',
        () {
          // act
          final result = ContactMessageDto.fromJson(json);
          // assert
          expect(result, equals(contactMessageDto));
        },
      );

      test(
        'toJson should return a JSON map containing the proper data',
        () {
          // act
          final result = contactMessageDto.toJson();
          // assert
          expect(result, equals(json));
        },
      );
    },
  );
}
