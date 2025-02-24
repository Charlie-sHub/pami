import 'package:flutter_test/flutter_test.dart';
import 'package:pami/data/core/models/coordinates_dto.dart';

import '../../../misc/get_valid_coordinates.dart';

void main() {
  final coordinates = getValidCoordinates();
  final coordinatesDto = CoordinatesDto.fromDomain(
    coordinates,
  );
  final json = coordinatesDto.toJson();

  group(
    'Testing on success',
    () {
      test(
        'fromDomain should return a valid DTO from a Coordinates entity',
        () {
          // act
          final result = CoordinatesDto.fromDomain(coordinates);
          // assert
          expect(result, equals(coordinatesDto));
        },
      );

      test(
        'toDomain should return a Coordinates entity from a valid DTO',
        () {
          // act
          final result = coordinatesDto.toDomain();
          // assert
          expect(result, equals(coordinates));
        },
      );

      test(
        'fromJson should return a valid DTO from a JSON map',
        () {
          // act
          final result = CoordinatesDto.fromJson(json);
          // assert
          expect(result, equals(coordinatesDto));
        },
      );

      test(
        'toJson should return a JSON map containing the proper data',
        () {
          // act
          final result = coordinatesDto.toJson();
          // assert
          expect(result, equals(json));
        },
      );
    },
  );
}
