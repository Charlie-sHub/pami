import 'package:flutter_test/flutter_test.dart';
import 'package:pami/data/core/models/user_dto.dart';

import '../../../misc/get_valid_user.dart';

void main() {
  final user = getValidUser();
  final userDto = UserDto.fromDomain(user);
  final json = userDto.toJson();

  group(
    'Testing on success',
    () {
      test(
        'fromDomain should return a valid DTO from a User entity',
        () {
          // act
          final result = UserDto.fromDomain(user);
          // assert
          expect(result, equals(userDto));
        },
      );

      test(
        'toDomain should return a User entity from a valid DTO',
        () {
          // act
          final result = userDto.toDomain();
          // assert
          expect(result, equals(user));
        },
      );

      test(
        'fromJson should return a valid DTO from a JSON map',
        () {
          // act
          final result = UserDto.fromJson(json);
          // assert
          expect(result, equals(userDto));
        },
      );

      test(
        'toJson should return a JSON map containing the proper data',
        () {
          // act
          final result = userDto.toJson();
          // assert
          expect(result, equals(json));
        },
      );
    },
  );
}
