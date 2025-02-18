import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

import '../../../misc/get_valid_user.dart';

void main() {
  late User validUser;
  late User invalidEmailUser;
  late User invalidNameUser;
  late User invalidUsernameUser;
  late User invalidBioUser;
  late User invalidAvatarUser;
  late User invalidKarmaUser;
  late User invalidLastLoginUser;
  late User invalidDateCreatedUser;

  setUp(
    () {
      // Arrange
      validUser = getValidUser();
      invalidEmailUser = validUser.copyWith(
        email: EmailAddress('invalid-email'),
      );
      invalidNameUser = validUser.copyWith(
        name: Name(''),
      );
      invalidUsernameUser = validUser.copyWith(
        username: Name(''),
      );
      invalidBioUser = validUser.copyWith(
        bio: EntityDescription(''),
      );
      invalidAvatarUser = validUser.copyWith(
        avatar: Url('invalid-url'),
      );
      invalidKarmaUser = validUser.copyWith(
        karma: KarmaPercentage(-1),
      );
      invalidLastLoginUser = validUser.copyWith(
        lastLogin: PastDate(
          DateTime.now().add(const Duration(days: 10)),
        ),
      );
      invalidDateCreatedUser = validUser.copyWith(
        dateCreated: PastDate(
          DateTime.now().add(const Duration(days: 10)),
        ),
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
          final result = validUser.isValid;

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return none when all inputs are valid',
        () {
          // Act
          final result = validUser.failureOption;

          // Assert
          expect(result, none());
        },
      );

      test(
        'should return right(unit) when all inputs are valid',
        () {
          // Act
          final result = validUser.failureOrUnit;

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
        'should be invalid with invalidEmailUser',
        () {
          // Act
          final result = invalidEmailUser.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidNameUser',
        () {
          // Act
          final result = invalidNameUser.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidUsernameUser',
        () {
          // Act
          final result = invalidUsernameUser.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidBioUser',
        () {
          // Act
          final result = invalidBioUser.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidAvatarUser',
        () {
          // Act
          final result = invalidAvatarUser.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidKarmaUser',
        () {
          // Act
          final result = invalidKarmaUser.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidLastLoginUser',
        () {
          // Act
          final result = invalidLastLoginUser.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should be invalid with invalidDateCreatedUser',
        () {
          // Act
          final result = invalidDateCreatedUser.isValid;

          // Assert
          expect(result, false);
        },
      );

      test(
        'should return some when email is invalid',
        () {
          // Act
          final result = invalidEmailUser.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when name is invalid',
        () {
          // Act
          final result = invalidNameUser.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when username is invalid',
        () {
          // Act
          final result = invalidUsernameUser.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when bio is invalid',
        () {
          // Act
          final result = invalidBioUser.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when avatar is invalid',
        () {
          // Act
          final result = invalidAvatarUser.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when karma is invalid',
        () {
          // Act
          final result = invalidKarmaUser.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when lastLogin is invalid',
        () {
          // Act
          final result = invalidLastLoginUser.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return some when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedUser.failureOption;

          // Assert
          expect(result, isA<Some<Failure<dynamic>>>());
        },
      );

      test(
        'should return left when email is invalid',
        () {
          // Act
          final result = invalidEmailUser.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when name is invalid',
        () {
          // Act
          final result = invalidNameUser.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when bio is invalid',
        () {
          // Act
          final result = invalidBioUser.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when avatar is invalid',
        () {
          // Act
          final result = invalidAvatarUser.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when karma is invalid',
        () {
          // Act
          final result = invalidKarmaUser.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when lastLogin is invalid',
        () {
          // Act
          final result = invalidLastLoginUser.failureOrUnit;

          // Assert
          expect(result, isA<Left<Failure<dynamic>, Unit>>());
        },
      );

      test(
        'should return left when dateCreated is invalid',
        () {
          // Act
          final result = invalidDateCreatedUser.failureOrUnit;

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
        'should return a User with default values',
        () {
          // Act
          final user = User.empty();

          // Assert
          expect(user.id, isA<UniqueId>());
          expect(user.email, isA<EmailAddress>());
          expect(user.name, isA<Name>());
          expect(user.bio, isA<EntityDescription>());
          expect(user.avatar, isA<Url>());
          expect(user.isVerified, false);
          expect(user.karma, isA<KarmaPercentage>());
          expect(user.interestedShoutOutIds, <UniqueId>{});
          expect(user.lastLogin, isA<PastDate>());
          expect(user.dateCreated, isA<PastDate>());
        },
      );
    },
  );
}
