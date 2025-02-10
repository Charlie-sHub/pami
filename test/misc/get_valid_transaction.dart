import 'package:pami/domain/core/entities/transaction.dart';
import 'package:pami/domain/core/misc/enums/transaction_status.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:qr_flutter/qr_flutter.dart';

Transaction getValidTransaction() => Transaction(
      id: UniqueId(),
      shoutOutCreatorId: UniqueId(),
      interestedId: UniqueId(),
      status: TransactionStatus.confirmed,
      qrCode: QrCode(
        1,
        QrErrorCorrectLevel.L,
      ),
      dateCreated: PastDate(DateTime.now()),
    );
