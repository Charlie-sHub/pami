import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/app_failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the profile repository
abstract class ProfileRepositoryInterface {
  /// Returns the [User] with the given [id]
  Future<Either<AppFailure, User>> getUserProfile(UniqueId id);

  /// Returns the [User] that is currently signed in
  Future<Either<AppFailure, User>> getCurrentUser();

  /// Updates the [User] with the given [user]
  Future<Either<AppFailure, Unit>> updateUserProfile(User user);

  /// Deletes the signed in [User]
  Future<Either<AppFailure, Unit>> deleteUser();
}
