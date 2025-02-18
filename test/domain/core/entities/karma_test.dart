import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/karma.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

import '../../../misc/get_valid_karma.dart';

void main() {
  late Karma validKarma;
  late Karma invalidDateCreatedKarma;

  setUp(
    () {
      // Arrange
      validKarma = getValidKarma();
      invalidDateCreatedKarma = validKarma.copyWith(
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
          final result = validKarma.isValid;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () {
          // Act
          final result = validKarma.failureOption;

          // Assert
          expect(result, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Act
          final result = validKarma.failureOrUnit;

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
        'should be invalid with invalidDateCreatedKarma',
        () {
          // Act
          final result = invalidDateCreatedKarma.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedKarma.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedKarma.failureOrUnit;

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
        'should return a Karma with default values',
        () {
          // Act
          final karma = Karma.empty();

          // Assert
          expect(karma.id, isA<UniqueId>());
          expect(karma.giverId, isA<UniqueId>());
          expect(karma.transactionId, isA<UniqueId>());
          expect(karma.isPositive, false);
          expect(karma.dateCreated, isA<PastDate>());
        },
      );
    },
  );
}
