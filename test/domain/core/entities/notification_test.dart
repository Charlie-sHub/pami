import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/notification.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

void main() {
  final validNotification = getValidNotification();
  final invalidDescriptionNotification = validNotification.copyWith(
    description: EntityDescription(''),
  );
  final invalidDateCreatedNotification = validNotification.copyWith(
    dateCreated: PastDate(
      DateTime.now().add(const Duration(days: 1)),
    ),
  );

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () {
          // Act
          final result = validNotification.isValid;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () {
          // Act
          final result = validNotification.failureOption;

          // Assert
          expect(result, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Act
          final result = validNotification.failureOrUnit;

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
        'should be invalid when description is invalid',
        () {
          // Act
          final result = invalidDescriptionNotification.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return some when description is invalid',
        () {
          // Act
          final result = invalidDescriptionNotification.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return left when description is invalid',
        () {
          // Act
          final result = invalidDescriptionNotification.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should be invalid when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedNotification.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedNotification.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedNotification.failureOrUnit;

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
        'should return a Notification with default values',
        () {
          // Act
          final notification = Notification.empty();

          // Assert
          expect(notification.id, isA<UniqueId>());
          expect(notification.description, isA<EntityDescription>());
          expect(notification.seen, false);
          expect(notification.dateCreated, isA<PastDate>());
        },
      );
    },
  );
}
