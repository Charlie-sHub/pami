import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

import '../../../misc/get_valid_shout_out.dart';

void main() {
  late ShoutOut validShoutOut;
  late ShoutOut invalidTitleShoutOut;
  late ShoutOut invalidDescriptionShoutOut;
  late ShoutOut invalidCoordinatesShoutOut;
  late ShoutOut invalidDurationShoutOut;
  late ShoutOut invalidDateCreatedShoutOut;

  setUp(
    () {
      // Arrange
      validShoutOut = getValidShoutOut();
      invalidTitleShoutOut = validShoutOut.copyWith(
        title: Name(''),
      );
      invalidDescriptionShoutOut = validShoutOut.copyWith(
        description: EntityDescription(''),
      );
      invalidCoordinatesShoutOut = validShoutOut.copyWith(
        coordinates: Coordinates(
          latitude: Latitude(91),
          longitude: Longitude(181),
        ),
      );
      invalidDurationShoutOut = validShoutOut.copyWith(
        duration: Minutes(-1),
      );
      invalidDateCreatedShoutOut = validShoutOut.copyWith(
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
          final result = validShoutOut.isValid;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () {
          // Act
          final result = validShoutOut.failureOption;

          // Assert
          expect(result, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Act
          final result = validShoutOut.failureOrUnit;

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
        'should be invalid with invalidTitleShoutOut',
        () {
          // Act
          final result = invalidTitleShoutOut.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidDescriptionShoutOut',
        () {
          // Act
          final result = invalidDescriptionShoutOut.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidCoordinatesShoutOut',
        () {
          // Act
          final result = invalidCoordinatesShoutOut.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidDurationShoutOut',
        () {
          // Act
          final result = invalidDurationShoutOut.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidDateCreatedShoutOut',
        () {
          // Act
          final result = invalidDateCreatedShoutOut.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return some when title is invalid',
        () {
          // Act
          final result = invalidTitleShoutOut.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when description is invalid',
        () {
          // Act
          final result = invalidDescriptionShoutOut.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when coordinates is invalid',
        () {
          // Act
          final result = invalidCoordinatesShoutOut.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when duration is invalid',
        () {
          // Act
          final result = invalidDurationShoutOut.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedShoutOut.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return left when title is invalid',
        () {
          // Act
          final result = invalidTitleShoutOut.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when description is invalid',
        () {
          // Act
          final result = invalidDescriptionShoutOut.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when coordinates is invalid',
        () {
          // Act
          final result = invalidCoordinatesShoutOut.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when duration is invalid',
        () {
          // Act
          final result = invalidDurationShoutOut.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedShoutOut.failureOrUnit;

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
        'should return a ShoutOut with default values',
        () {
          // Act
          final shoutOut = ShoutOut.empty();

          // Assert
          expect(shoutOut.id, isA<UniqueId>());
          expect(shoutOut.creatorId, isA<UniqueId>());
          expect(shoutOut.type, isA<ShoutOutType>());
          expect(shoutOut.title, isA<Name>());
          expect(shoutOut.description, isA<EntityDescription>());
          expect(shoutOut.coordinates, isA<Coordinates>());
          expect(shoutOut.duration, isA<Minutes>());
          expect(shoutOut.categories, <Category>{});
          expect(shoutOut.imageUrls, <Url>{});
          expect(shoutOut.isOpen, false);
          expect(shoutOut.dateCreated, isA<PastDate>());
        },
      );
    },
  );
}
