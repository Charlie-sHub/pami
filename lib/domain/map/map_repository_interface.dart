import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Interface for the map repository
abstract class MapRepositoryInterface {
  /// Fetches the shout outs of the current user based on the [settings]
  Stream<Either<Failure, Set<ShoutOut>>> watchShoutOuts(
    MapSettings settings,
  );

  /// Get current location (one-time request)
  Future<Either<Failure, Coordinates>> getCurrentLocation();

  /// Stream user’s live location
  Stream<Either<Failure, Coordinates>> getUserLocationStream();
}
