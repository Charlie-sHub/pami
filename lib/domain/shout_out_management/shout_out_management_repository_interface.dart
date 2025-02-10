import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Interface for the shout out management repository
abstract class ShoutOutManagementRepositoryInterface {
  /// Creates a new shout out
  Future<Either<Failure, Unit>> createShoutOut(ShoutOut shoutOut);

  /// Edits an existing shout out
  Future<Either<Failure, Unit>> editShoutOut(ShoutOut shoutOut);
}
