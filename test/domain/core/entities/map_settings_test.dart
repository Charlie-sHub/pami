import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

import '../../../misc/get_valid_map_settings.dart';

void main() {
  final validMapSettings = getValidMapSettings();
  final invalidRadiusMapSettings = validMapSettings.copyWith(
    radius: MapRadius(-1),
  );

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () async {
          // Assert
          expect(validMapSettings.isValid, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () async {
          // Assert
          expect(validMapSettings.failureOption, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () async {
          // Assert
          expect(validMapSettings.failureOrUnit, right(unit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidRadiusMapSettings',
        () async {
          // Assert
          expect(invalidRadiusMapSettings.isValid, false);
        },
      );

      test(
        'should return some when radius is invalid',
        () async {
          // Assert
          expect(
            invalidRadiusMapSettings.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return left when radius is invalid',
        () async {
          // Assert
          expect(
            invalidRadiusMapSettings.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );
    },
  );
}
