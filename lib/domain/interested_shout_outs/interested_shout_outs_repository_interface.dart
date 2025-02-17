import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Interface for the interested shout outs repository
abstract class InterestedShoutOutsRepositoryInterface {
  /// Fetches the interested shout outs
  Stream<Either<Failure, Set<ShoutOut>>> watchInterestedShoutOuts();
}
