import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';

import '../../../misc/get_valid_coordinates.dart';

void main() {
  late Coordinates validCoordinates;
  late Coordinates invalidLatitudeCoordinates;
  late Coordinates invalidLongitudeCoordinates;

  setUp(
    () {
      // Arrange
      validCoordinates = getValidCoordinates();
      invalidLatitudeCoordinates = validCoordinates.copyWith(
        latitude: Latitude(-91),
      );
      invalidLongitudeCoordinates = validCoordinates.copyWith(
        longitude: Longitude(-181),
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
          final result = validCoordinates.isValid;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () {
          // Act
          final result = validCoordinates.failureOption;

          // Assert
          expect(result, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Act
          final result = validCoordinates.failureOrUnit;

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
        'should be invalid with invalidLatitudeCoordinates',
        () {
          // Act
          final result = invalidLatitudeCoordinates.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidLongitudeCoordinates',
        () {
          // Act
          final result = invalidLongitudeCoordinates.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return some when latitude is invalid',
        () {
          // Act
          final result = invalidLatitudeCoordinates.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when longitude is invalid',
        () {
          // Act
          final result = invalidLongitudeCoordinates.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return left when latitude is invalid',
        () {
          // Act
          final result = invalidLatitudeCoordinates.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when longitude is invalid',
        () {
          // Act
          final result = invalidLongitudeCoordinates.failureOrUnit;

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
        'should return a Coordinates with default values',
        () {
          // Act
          final coordinates = Coordinates.empty();

          // Assert
          expect(coordinates.latitude, isA<Latitude>());
          expect(coordinates.longitude, isA<Longitude>());
        },
      );
    },
  );
}
