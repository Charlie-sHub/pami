import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the profile repository
abstract class ProfileRepositoryInterface {
  /// Returns the [User] with the given [id]
  Future<Either<Failure, User>> getUserProfile(UniqueId id);

  /// Updates the [User] with the given [user]
  Future<Either<Failure, Unit>> updateUserProfile(User user);

  /// Deletes the signed in [User]
  Future<Either<Failure, Unit>> deleteUser();
}
