import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';

User getValidUser() => User(
      id: UniqueId(),
      email: EmailAddress('test@test.test'),
      name: Name('test'),
      bio: EntityDescription('test'),
      avatar: Url('https://www.test.test'),
      isVerified: false,
      karma: KarmaPercentage(0),
      interestedShoutOutIds: {UniqueId()},
      lastLogin: PastDate(DateTime.now()),
      dateCreated: PastDate(DateTime.now()),
    );
