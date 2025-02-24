import 'package:flutter_test/flutter_test.dart';
import 'package:pami/data/core/models/shout_out_dto.dart';

import '../../../misc/get_valid_shout_out.dart';

void main() {
  final shoutOut = getValidShoutOut();
  final shoutOutDto = ShoutOutDto.fromDomain(shoutOut);
  final json = shoutOutDto.toJson();

  group(
    'Testing on success',
    () {
      test(
        'fromDomain should return a valid DTO from a ShoutOut entity',
        () {
          // act
          final result = ShoutOutDto.fromDomain(shoutOut);
          // assert
          expect(result, equals(shoutOutDto));
        },
      );

      test(
        'toDomain should return a ShoutOut entity from a valid DTO',
        () {
          // act
          final result = shoutOutDto.toDomain();
          // assert
          expect(result.id, equals(shoutOut.id));
          expect(result.creatorId, equals(shoutOut.creatorId));
          expect(result.type, equals(shoutOut.type));
          expect(result.title, equals(shoutOut.title));
          expect(result.description, equals(shoutOut.description));
          expect(result.coordinates, equals(shoutOut.coordinates));
          expect(result.duration, equals(shoutOut.duration));
          expect(result.categories, equals(shoutOut.categories));
          expect(result.imageUrls, equals(shoutOut.imageUrls));
          expect(result.isOpen, equals(shoutOut.isOpen));
          expect(result.dateCreated, equals(shoutOut.dateCreated));
        },
      );

      test(
        'fromJson should return a valid DTO from a JSON map',
        () {
          // act
          final result = ShoutOutDto.fromJson(json);
          // assert
          expect(result, equals(shoutOutDto));
        },
      );

      test(
        'toJson should return a JSON map containing the proper data',
        () {
          // act
          final result = shoutOutDto.toJson();
          // assert
          expect(result, equals(json));
        },
      );
    },
  );
}
