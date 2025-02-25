import 'package:flutter_test/flutter_test.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/data/core/models/settings_dto.dart';

void main() {
  final settings = getValidSettings();
  final settingsDto = SettingsDto.fromDomain(settings);
  final json = settingsDto.toJson();

  group(
    'Testing on success',
    () {
      test(
        'fromDomain should return a valid DTO from a Settings entity',
        () {
          // act
          final result = SettingsDto.fromDomain(settings);
          // assert
          expect(result, equals(settingsDto));
        },
      );

      test(
        'toDomain should return a Settings entity from a valid DTO',
        () {
          // act
          final result = settingsDto.toDomain();
          // assert
          expect(result, equals(settings));
        },
      );

      test(
        'fromJson should return a valid DTO from a JSON map',
        () {
          // act
          final result = SettingsDto.fromJson(json);
          // assert
          expect(result, equals(settingsDto));
        },
      );

      test(
        'toJson should return a JSON map containing the proper data',
        () {
          // act
          final result = settingsDto.toJson();
          // assert
          expect(result, equals(json));
        },
      );
    },
  );
}
