import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';

import '../../../misc/get_valid_message.dart';

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
  final invalidContentAndDateCreatedMessage = validMessage.copyWith(
    content: MessageContent(''),
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
          expect(validMessage.isValid, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () async {
          // Assert
          expect(validMessage.failureOption, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () async {
          // Assert
          expect(validMessage.failureOrUnit, right(unit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidContentMessage',
        () async {
          // Assert
          expect(invalidContentMessage.isValid, false);
        },
      );

      test(
        'should be invalid with invalidDateCreatedMessage',
        () async {
          // Assert
          expect(invalidDateCreatedMessage.isValid, false);
        },
      );

      test(
        'should be invalid with invalidContentAndDateCreatedMessage',
        () async {
          // Assert
          expect(invalidContentAndDateCreatedMessage.isValid, false);
        },
      );

      test(
        'should return some when content is invalid',
        () async {
          // Assert
          expect(
            invalidContentMessage.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () async {
          // Assert
          expect(
            invalidDateCreatedMessage.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when content and dateCreated are invalid',
        () async {
          // Assert
          expect(
            invalidContentAndDateCreatedMessage.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return left when content is invalid',
        () async {
          // Assert
          expect(
            invalidContentMessage.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () async {
          // Assert
          expect(
            invalidDateCreatedMessage.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when content and dateCreated are invalid',
        () async {
          // Assert
          expect(
            invalidContentAndDateCreatedMessage.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );
    },
  );
}
