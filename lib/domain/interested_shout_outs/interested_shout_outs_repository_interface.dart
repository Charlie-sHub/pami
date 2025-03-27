import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the interested shout outs repository
abstract class InterestedShoutOutsRepositoryInterface {
  /// Fetches the interested shout outs
  Stream<Either<Failure, Set<ShoutOut>>> watchInterestedShoutOuts();

  /// Adds a shout out to the list of interested shout outs
  Future<Either<Failure, Unit>> addInterestedShoutOut(UniqueId shoutOutId);
}
