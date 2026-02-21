import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/app_failure.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/profile/profile_repository_interface.dart';

// coverage:ignore-files
/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: ProfileRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentProfileRepository implements ProfileRepositoryInterface {
  /// Default constructor
  DevelopmentProfileRepository(this._logger);

  final Logger _logger;

  @override
  Future<Either<AppFailure, User>> getUserProfile(UniqueId id) async {
    _logger.d('Getting user profile with id: ${id.getOrCrash()}');
    final user = getValidUser().copyWith(id: id);
    _logger.d('Returning mock user: ${user.id}');
    return right(user);
  }

  @override
  Future<Either<AppFailure, User>> getCurrentUser() async {
    _logger.d('Getting current user profile...');
    final user = getValidUser().copyWith(
      name: Name('John'),
      username: Name('johnny_xx'),
      bio: EntityDescription(
        'Lorem ipsum dolor sit amet, consectetur '
        'adipiscing elit, sed do eiusmod tempor incididunt ut labore et '
        'dolore magna aliqua. Ut enim ad minim veniam, quis nostrud',
      ),
      karma: KarmaPercentage(76),
      isVerified: true,
    );
    _logger.d('Returning mock user: ${user.id}');
    return right(user);
  }

  @override
  Future<Either<AppFailure, Unit>> updateUserProfile(User user) async {
    _logger.d('Updating user profile: ${user.id.getOrCrash()}');
    return right(unit);
  }

  @override
  Future<Either<AppFailure, Unit>> deleteUser() async {
    _logger.d('Deleting user...');
    return right(unit);
  }
}
