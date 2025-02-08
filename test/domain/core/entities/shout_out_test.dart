import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';

import '../../../misc/get_valid_shout_out.dart';

void main() {
  final validShoutOut = getValidShoutOut();
  final invalidTitleShoutOut = validShoutOut.copyWith(
    title: Name(''),
  );
  final invalidDescriptionShoutOut = validShoutOut.copyWith(
    description: EntityDescription(''),
  );
  final invalidCoordinatesShoutOut = validShoutOut.copyWith(
    coordinates: Coordinates(
      latitude: Latitude(91),
      longitude: Longitude(181),
    ),
  );
  final invalidDurationShoutOut = validShoutOut.copyWith(
    duration: Minutes(-1),
  );
  final invalidDateCreatedShoutOut = validShoutOut.copyWith(
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
          expect(validShoutOut.isValid, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () async {
          // Assert
          expect(validShoutOut.failureOption, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () async {
          // Assert
          expect(validShoutOut.failureOrUnit, right(unit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidTitleShoutOut',
        () async {
          // Assert
          expect(invalidTitleShoutOut.isValid, false);
        },
      );

      test(
        'should be invalid with invalidDescriptionShoutOut',
        () async {
          // Assert
          expect(invalidDescriptionShoutOut.isValid, false);
        },
      );

      test(
        'should be invalid with invalidCoordinatesShoutOut',
        () async {
          // Assert
          expect(invalidCoordinatesShoutOut.isValid, false);
        },
      );

      test(
        'should be invalid with invalidDurationShoutOut',
        () async {
          // Assert
          expect(invalidDurationShoutOut.isValid, false);
        },
      );

      test(
        'should be invalid with invalidDateCreatedShoutOut',
        () async {
          // Assert
          expect(invalidDateCreatedShoutOut.isValid, false);
        },
      );

      test(
        'should return some when title is invalid',
        () async {
          // Assert
          expect(
            invalidTitleShoutOut.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when description is invalid',
        () async {
          // Assert
          expect(
            invalidDescriptionShoutOut.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when coordinates is invalid',
        () async {
          // Assert
          expect(
            invalidCoordinatesShoutOut.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when duration is invalid',
        () async {
          // Assert
          expect(
            invalidDurationShoutOut.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () async {
          // Assert
          expect(
            invalidDateCreatedShoutOut.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );
    },
  );
}
