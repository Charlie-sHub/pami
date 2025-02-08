import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

import '../../../misc/get_valid_user.dart';

void main() {
  final validUser = getValidUser();
  final invalidEmailUser = validUser.copyWith(
    email: EmailAddress('invalid-email'),
  );
  final invalidNameUser = validUser.copyWith(
    name: Name(''),
  );
  final invalidBioUser = validUser.copyWith(
    bio: EntityDescription(''),
  );
  final invalidAvatarUser = validUser.copyWith(
    avatar: Url('invalid-url'),
  );
  final invalidKarmaUser = validUser.copyWith(
    karma: KarmaPercentage(-1),
  );
  final invalidLastLoginUser = validUser.copyWith(
    lastLogin: PastDate(
      DateTime.now().add(const Duration(days: 10)),
    ),
  );
  final invalidDateCreatedUser = validUser.copyWith(
    dateCreated: PastDate(
      DateTime.now().add(const Duration(days: 10)),
    ),
  );

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () async {
          // Assert
          expect(validUser.isValid, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () async {
          // Assert
          expect(validUser.failureOption, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () async {
          // Assert
          expect(validUser.failureOrUnit, right(unit));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'should be invalid with invalidEmailUser',
        () async {
          // Assert
          expect(invalidEmailUser.isValid, false);
        },
      );

      test(
        'should be invalid with invalidNameUser',
        () async {
          // Assert
          expect(invalidNameUser.isValid, false);
        },
      );

      test(
        'should be invalid with invalidBioUser',
        () async {
          // Assert
          expect(invalidBioUser.isValid, false);
        },
      );

      test(
        'should be invalid with invalidAvatarUser',
        () async {
          // Assert
          expect(invalidAvatarUser.isValid, false);
        },
      );

      test(
        'should be invalid with invalidKarmaUser',
        () async {
          // Assert
          expect(invalidKarmaUser.isValid, false);
        },
      );

      test(
        'should be invalid with invalidLastLoginUser',
        () async {
          // Assert
          expect(invalidLastLoginUser.isValid, false);
        },
      );

      test(
        'should be invalid with invalidDateCreatedUser',
        () async {
          // Assert
          expect(invalidDateCreatedUser.isValid, false);
        },
      );

      test(
        'should return some when email is invalid',
        () async {
          // Assert
          expect(invalidEmailUser.failureOption, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when name is invalid',
        () async {
          // Assert
          expect(invalidNameUser.failureOption, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when bio is invalid',
        () async {
          // Assert
          expect(invalidBioUser.failureOption, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when avatar is invalid',
        () async {
          // Assert
          expect(
            invalidAvatarUser.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when karma is invalid',
        () async {
          // Assert
          expect(invalidKarmaUser.failureOption, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when lastLogin is invalid',
        () async {
          // Assert
          expect(
            invalidLastLoginUser.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () async {
          // Assert
          expect(
            invalidDateCreatedUser.failureOption,
            isA<Some<Failure<dynamic>>>(),
          );
        },
      );

      test(
        'should return left when email is invalid',
        () async {
          // Assert
          expect(
            invalidEmailUser.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when name is invalid',
        () async {
          // Assert
          expect(
            invalidNameUser.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when bio is invalid',
        () async {
          // Assert
          expect(
            invalidBioUser.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when avatar is invalid',
        () async {
          // Assert
          expect(
            invalidAvatarUser.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when karma is invalid',
        () async {
          // Assert
          expect(
            invalidKarmaUser.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when lastLogin is invalid',
        () async {
          // Assert
          expect(
            invalidLastLoginUser.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () async {
          // Assert
          expect(
            invalidDateCreatedUser.failureOrUnit,
            isA<Left<Failure<dynamic>, Unit>>(),
          );
        },
      );
    },
  );
}
