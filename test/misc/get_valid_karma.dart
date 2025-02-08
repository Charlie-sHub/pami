import 'package:pami/domain/core/entities/karma.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

Karma getValidKarma() => Karma(
      id: UniqueId(),
      giverId: UniqueId(),
      transactionId: UniqueId(),
      isPositive: true,
      dateCreated: PastDate(DateTime.now()),
    );
