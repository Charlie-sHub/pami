import 'package:flutter_test/flutter_test.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/data/core/models/karma_dto.dart';

void main() {
  final karma = getValidKarma();
  final karmaDto = KarmaDto.fromDomain(karma);
  final json = karmaDto.toJson();

  group(
    'Testing on success',
    () {
      test(
        'fromDomain should return a valid DTO from a Karma entity',
        () {
          // act
          final result = KarmaDto.fromDomain(karma);
          // assert
          expect(result, equals(karmaDto));
        },
      );

      test(
        'toDomain should return a Karma entity from a valid DTO',
        () {
          // act
          final result = karmaDto.toDomain();
          // assert
          expect(result, equals(karma));
        },
      );

      test(
        'fromJson should return a valid DTO from a JSON map',
        () {
          // act
          final result = KarmaDto.fromJson(json);
          // assert
          expect(result, equals(karmaDto));
        },
      );

      test(
        'toJson should return a JSON map containing the proper data',
        () {
          // act
          final result = karmaDto.toJson();
          // assert
          expect(result, equals(json));
        },
      );
    },
  );
}
