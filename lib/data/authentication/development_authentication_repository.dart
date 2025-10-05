import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/authentication/authentication_repository_interface.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/password.dart';

// coverage:ignore-files
/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: AuthenticationRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentAuthenticationRepository
    implements AuthenticationRepositoryInterface {
  /// Default constructor
  DevelopmentAuthenticationRepository(this._logger);

  final Logger _logger;

  @override
  Future<Option<User>> getLoggedInUser() async {
    _logger.d('Fetching logged-in user...');
    final user = getValidUser();
    _logger.d('Returning mock user: ${user.id}');
    return some(user);
  }

  @override
  Future<Either<Failure, Unit>> logIn({
    required EmailAddress email,
    required Password password,
  }) async {
    _logger.d('Attempting login with email: ${email.getOrCrash()}');
    return right(unit);
  }

  @override
  Future<Either<Failure, Option<User>>> logInApple() async {
    _logger.d('Attempting Apple login...');
    final user = getValidUser();
    _logger.d('Apple login successful, returning user: ${user.id}');
    return right(some(user));
  }

  @override
  Future<Either<Failure, Option<User>>> logInGoogle() async {
    _logger.d('Attempting Google login...');
    final user = getValidUser();
    _logger.d('Google login successful, returning user: ${user.id}');
    return right(some(user));
  }

  @override
  Future<void> logOut() async {
    _logger.d('Logging out user...');
  }

  @override
  Future<Either<Failure, Unit>> register({
    required User user,
    required Password password,
    required XFile imageFile,
  }) async {
    _logger.d(
      'Registering user: ${user.id} with email: ${user.email.getOrCrash()}',
    );
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(EmailAddress emailAddress) async {
    _logger.d('Resetting password for email: ${emailAddress.getOrCrash()}');
    return right(unit);
  }
}
