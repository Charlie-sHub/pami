import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/contact_message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/contact_message_type.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

import '../../../misc/get_valid_contact_message.dart';

void main() {
  late ContactMessage validContactMessage;
  late ContactMessage invalidContentContactMessage;
  late ContactMessage invalidDateCreatedContactMessage;

  setUp(
    () {
      // Arrange
      validContactMessage = getValidContactMessage();
      invalidContentContactMessage = validContactMessage.copyWith(
        content: MessageContent(''),
      );
      invalidDateCreatedContactMessage = validContactMessage.copyWith(
        dateCreated: PastDate(
          DateTime.now().add(const Duration(days: 10)),
        ),
      );
    },
  );

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () {
          // Act
          final result = validContactMessage.isValid;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () {
          // Act
          final result = validContactMessage.failureOption;

          // Assert
          expect(result, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Act
          final result = validContactMessage.failureOrUnit;

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
        'should be invalid with invalidContentContactMessage',
        () {
          // Act
          final result = invalidContentContactMessage.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidDateCreatedContactMessage',
        () {
          // Act
          final result = invalidDateCreatedContactMessage.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return some when content is invalid',
        () {
          // Act
          final result = invalidContentContactMessage.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedContactMessage.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return left when content is invalid',
        () {
          // Act
          final result = invalidContentContactMessage.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedContactMessage.failureOrUnit;

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
        'should return a ContactMessage with default values',
        () {
          // Act
          final contactMessage = ContactMessage.empty();

          // Assert
          expect(contactMessage.id, isA<UniqueId>());
          expect(contactMessage.senderId, isA<UniqueId>());
          expect(contactMessage.content, isA<MessageContent>());
          expect(contactMessage.type, ContactMessageType.other);
          expect(contactMessage.dateCreated, isA<PastDate>());
        },
      );
    },
  );
}
