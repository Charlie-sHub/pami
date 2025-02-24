import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'get_valid_coordinates.dart';

ShoutOut getValidShoutOut() {
  final id = UniqueId();
  return ShoutOut(
    id: id,
    creatorId: UniqueId(),
    type: ShoutOutType.offer,
    title: Name('test'),
    description: EntityDescription('test'),
    coordinates: getValidCoordinates(),
    duration: Minutes(0),
    categories: {Category.financial},
    imageUrls: {Url('https://www.test.test')},
    isOpen: true,
    dateCreated: PastDate(DateTime.now()),
    qrCode: QrCode.fromData(
      data: id.getOrCrash(),
      errorCorrectLevel: QrErrorCorrectLevel.M,
    ),
  );
}
