import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/my_shout_outs/my_shout_outs_repository_interface.dart';

// coverage:ignore-files
/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: MyShoutOutsRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentMyShoutOutsRepository
    implements MyShoutOutsRepositoryInterface {
  /// Default constructor
  DevelopmentMyShoutOutsRepository(this._logger);

  final Logger _logger;

  @override
  Stream<Either<Failure, Set<ShoutOut>>> watchMyShoutOuts() {
    _logger.d('Watching my shout outs...');

    final shoutOuts = {
      getValidShoutOut().copyWith(
        id: UniqueId(),
        title: Name('Lesson'),
        description: EntityDescription(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
          'sed do eiusmod tempor incididunt ut labore et dolore magna '
          'aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
        ),
        creatorUser: none(),
      ),
      getValidShoutOut().copyWith(
        id: UniqueId(),
        title: Name('Cables'),
        description: EntityDescription(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
          'sed do eiusmod tempor incididunt ut labore et dolore magna '
          'aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
        ),
        isOpen: false,
        creatorUser: none(),
      ),
      getValidShoutOut().copyWith(
        id: UniqueId(),
        title: Name('Stuff'),
        description: EntityDescription(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
          'sed do eiusmod tempor incididunt ut labore et dolore magna '
          'aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
        ),
        type: ShoutOutType.request,
        creatorUser: none(),
      ),
    };

    _logger.d(
      'Returning mock shout outs: ${shoutOuts.map((shoutOut) => shoutOut.id)}',
    );
    return Stream.value(right(shoutOuts));
  }
}
