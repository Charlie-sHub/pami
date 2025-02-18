import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

import '../../../misc/get_valid_map_settings.dart';

void main() {
  late MapSettings validMapSettings;
  late MapSettings invalidRadiusMapSettings;

  setUp(
    () {
      // Arrange
      validMapSettings = getValidMapSettings();
      invalidRadiusMapSettings = validMapSettings.copyWith(
        radius: MapRadius(-1),
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
          final result = validMapSettings.isValid;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () {
          // Act
          final result = validMapSettings.failureOption;

          // Assert
          expect(result, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Act
          final result = validMapSettings.failureOrUnit;

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
        'should be invalid with invalidRadiusMapSettings',
        () {
          // Act
          final result = invalidRadiusMapSettings.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return some when radius is invalid',
        () {
          // Act
          final result = invalidRadiusMapSettings.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return left when radius is invalid',
        () {
          // Act
          final result = invalidRadiusMapSettings.failureOrUnit;

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
        'should return a MapSettings with default values',
        () {
          // Act
          final mapSettings = MapSettings.empty();

          // Assert
          expect(mapSettings.radius, isA<MapRadius>());
          expect(mapSettings.type, ShoutOutType.offer);
          expect(mapSettings.categories, <Category>{});
        },
      );
    },
  );
}
