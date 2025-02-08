import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';

Coordinates getValidCoordinates() => Coordinates(
      latitude: Latitude(0),
      longitude: Longitude(0),
    );
