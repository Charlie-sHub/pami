import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Interface for the map repository
abstract class MapRepositoryInterface {
  /// Fetches the shout outs of the current user based on the [settings]
  Stream<Either<Failure, Set<ShoutOut>>> watchShoutOuts(
    MapSettings settings,
  );
}
