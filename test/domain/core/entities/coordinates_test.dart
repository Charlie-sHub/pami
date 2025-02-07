import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';

void main() {
  group(
    'Constructor',
    () {
      test(
        'should create a valid Coordinates when all inputs are valid',
        () {
          // Arrange
          final latitude = Latitude(40.7128);
          final longitude = Longitude(-74.0060);

          // Act
          final coordinates = Coordinates(
            latitude: latitude,
            longitude: longitude,
          );

          // Assert
          expect(coordinates.latitude, latitude);
          expect(coordinates.longitude, longitude);
          expect(coordinates.isValid, true);
          expect(coordinates.failureOrUnit, right(unit));
        },
      );
    },
  );

  group(
    'Empty Constructor',
    () {
      test(
        'should create an empty Coordinates with default values',
        () {
          // Act
          final coordinates = Coordinates.empty();

          // Assert
          expect(coordinates.latitude, Latitude(0));
          expect(coordinates.longitude, Longitude(0));
          expect(coordinates.isValid, true);
          expect(coordinates.failureOrUnit, right(unit));
        },
      );
    },
  );

  group(
    'failureOrUnit',
    () {
      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Arrange
          final latitude = Latitude(40.7128);
          final longitude = Longitude(-74.0060);

          // Act
          final coordinates = Coordinates(
            latitude: latitude,
            longitude: longitude,
          );

          // Assert
          expect(coordinates.failureOrUnit, right(unit));
        },
      );

      test(
        'should return left when latitude is invalid',
        () {
          // Arrange
          final latitude = Latitude(100);
          final longitude = Longitude(-74.0060);

          // Act
          final coordinates = Coordinates(
            latitude: latitude,
            longitude: longitude,
          );

          // Assert
          expect(
            coordinates.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when longitude is invalid',
        () {
          // Arrange
          final latitude = Latitude(40.7128);
          final longitude = Longitude(-200);

          // Act
          final coordinates = Coordinates(
            latitude: latitude,
            longitude: longitude,
          );

          // Assert
          expect(
            coordinates.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );
    },
  );

  group(
    'isValid',
    () {
      test(
        'should return true when all inputs are valid',
        () {
          // Arrange
          final latitude = Latitude(40.7128);
          final longitude = Longitude(-74.0060);

          // Act
          final coordinates = Coordinates(
            latitude: latitude,
            longitude: longitude,
          );

          // Assert
          expect(coordinates.isValid, true);
        },
      );

      test(
        'should return false when latitude is invalid',
        () {
          // Arrange
          final latitude = Latitude(100);
          final longitude = Longitude(-74.0060);

          // Act
          final coordinates = Coordinates(
            latitude: latitude,
            longitude: longitude,
          );

          // Assert
          expect(coordinates.isValid, false);
        },
      );

      test(
        'should return false when longitude is invalid',
        () {
          // Arrange
          final latitude = Latitude(40.7128);
          final longitude = Longitude(-200);

          // Act
          final coordinates = Coordinates(
            latitude: latitude,
            longitude: longitude,
          );

          // Assert
          expect(coordinates.isValid, false);
        },
      );
    },
  );
}
