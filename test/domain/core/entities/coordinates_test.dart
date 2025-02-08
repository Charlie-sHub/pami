import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';

import '../../../misc/get_valid_coordinates.dart';

void main() {
  final validCoordinates = getValidCoordinates();
  final invalidLatitudeCoordinates = validCoordinates.copyWith(
    latitude: Latitude(-91),
  );
  final invalidLongitudeCoordinates = validCoordinates.copyWith(
    longitude: Longitude(-181),
  );
  final invalidLatitudeAndLongitudeCoordinates = validCoordinates.copyWith(
    latitude: Latitude(-91),
    longitude: Longitude(-181),
  );

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () async {
          // Assert
          expect(validCoordinates.isValid, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () async {
          // Assert
          expect(validCoordinates.failureOption, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () async {
          // Assert
          expect(validCoordinates.failureOrUnit, right(unit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidLatitudeCoordinates',
        () async {
          // Assert
          expect(invalidLatitudeCoordinates.isValid, false);
        },
      );

      test(
        'should be invalid with invalidLongitudeCoordinates',
        () async {
          // Assert
          expect(invalidLongitudeCoordinates.isValid, false);
        },
      );

      test(
        'should be invalid with invalidLatitudeAndLongitudeCoordinates',
        () async {
          // Assert
          expect(invalidLatitudeAndLongitudeCoordinates.isValid, false);
        },
      );

      test(
        'should return some when latitude is invalid',
        () async {
          // Assert
          expect(
            invalidLatitudeCoordinates.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when longitude is invalid',
        () async {
          // Assert
          expect(
            invalidLongitudeCoordinates.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when latitude and longitude are invalid',
        () async {
          // Assert
          expect(
            invalidLatitudeAndLongitudeCoordinates.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return left when latitude is invalid',
        () async {
          // Assert
          expect(
            invalidLatitudeCoordinates.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when longitude is invalid',
        () async {
          // Assert
          expect(
            invalidLongitudeCoordinates.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when latitude and longitude are invalid',
        () async {
          // Assert
          expect(
            invalidLatitudeAndLongitudeCoordinates.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );
    },
  );
}
