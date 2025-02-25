import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
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
        title: Name('Shout Out 1'),
        description: EntityDescription('Description 1'),
      ),
      getValidShoutOut().copyWith(
        id: UniqueId(),
        title: Name('Shout Out 2'),
        description: EntityDescription('Description 2'),
        isOpen: false,
      ),
      getValidShoutOut().copyWith(
        id: UniqueId(),
        title: Name('Shout Out 3'),
        description: EntityDescription('Description 3'),
        type: ShoutOutType.request,
      ),
    };

    _logger.d(
      'Returning mock shout outs: ${shoutOuts.map((shoutOut) => shoutOut.id)}',
    );
    return Stream.value(right(shoutOuts));
  }
}
