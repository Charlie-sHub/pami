import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Interface for the my shout outs repository
abstract class MyShoutOutsRepositoryInterface {
  /// Fetches the shout outs of the current user
  Stream<Either<Failure, Set<ShoutOut>>> watchMyShoutOuts();
}
