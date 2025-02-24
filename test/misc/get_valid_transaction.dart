import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/misc/enums/transaction_status.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

Transaction getValidTransaction() => Transaction(
      id: UniqueId(),
      shoutOutCreatorId: UniqueId(),
      interestedId: UniqueId(),
      status: TransactionStatus.confirmed,
      dateCreated: PastDate(DateTime.now()),
    );
