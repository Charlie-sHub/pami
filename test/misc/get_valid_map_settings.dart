import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

MapSettings getValidMapSettings() => MapSettings(
      radius: MapRadius(0),
      type: ShoutOutType.request,
      categories: {Category.financial},
    );
