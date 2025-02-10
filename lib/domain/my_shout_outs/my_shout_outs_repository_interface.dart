import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the my shout outs repository
abstract class MyShoutOutRepositoryInterface {
  /// Fetches the shout outs of the current user
  Future<Either<Failure, List<ShoutOut>>> fetchMyShoutOuts();

  /// Deletes the shout out with the given [id]
  Future<Either<Failure, Unit>> deleteShoutOut(UniqueId id);
}
