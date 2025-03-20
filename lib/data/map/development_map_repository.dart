import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/map/map_repository_interface.dart';

/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: MapRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentMapRepository implements MapRepositoryInterface {
  /// Default constructor
  DevelopmentMapRepository(this._logger);

  final Logger _logger;

  @override
  Stream<Either<Failure, Set<ShoutOut>>> watchShoutOuts(
    MapSettings settings,
  ) {
    _logger.d(
      'Watching shout outs with settings: '
      'Categories: ${settings.categories}, '
      'Radius: ${settings.radius.getOrCrash()}',
    );

    // Create a set of diverse ShoutOut objects
    final shoutOuts = {
      getValidShoutOut().copyWith(
        id: UniqueId(),
        title: Name('Burger and fries'),
        description: EntityDescription('Just some burger and fries'),
        coordinates: Coordinates(
          latitude: Latitude(43.26070),
          longitude: Longitude(-2.94972),
        ),
      ),
      getValidShoutOut().copyWith(
        id: UniqueId(),
        title: Name('Ticket to the movies'),
        description: EntityDescription("I like movies but i can't now"),
        coordinates: Coordinates(
          latitude: Latitude(43.26522),
          longitude: Longitude(-2.94872),
        ),
      ),
      getValidShoutOut().copyWith(
        id: UniqueId(),
        title: Name('Need help with something'),
        description: EntityDescription('I need help with the thing'),
        type: ShoutOutType.request,
        coordinates: Coordinates(
          latitude: Latitude(43.26056),
          longitude: Longitude(-2.95429),
        ),
      ),
    };

    _logger.d(
      'Returning mock shout outs: ${shoutOuts.map((shoutOut) => shoutOut.id)}',
    );
    return Stream.value(right(shoutOuts));
  }

  @override
  Future<Either<Failure, Coordinates>> getCurrentLocation() async => right(
        getValidCoordinates(),
      );

  @override
  Stream<Either<Failure, Coordinates>> getUserLocationStream() => Stream.value(
        right(getValidCoordinates()),
      );
}
