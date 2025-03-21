import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/email_address.dart';
import 'package:pami/domain/core/validation/objects/password.dart';

/// Interface for the authentication repository
abstract class AuthenticationRepositoryInterface {
  /// Returns the currently signed in user
  Future<Option<User>> getLoggedInUser();

  /// Registers a new user with the given email and password
  Future<Either<Failure, Unit>> register({
    required User user,
    required Password password,
    required XFile imageFile,
  });

  /// Signs in a user with the given email and password
  Future<Either<Failure, Unit>> logIn({
    required EmailAddress email,
    required Password password,
  });

  /// Signs in a user via Google
  Future<Either<Failure, Option<User>>> logInGoogle();

  /// Signs in a user via Apple
  Future<Either<Failure, Option<User>>> logInApple();

  /// Signs out the current user
  Future<void> logOut();

  /// Resets the password for the given email
  Future<Either<Failure, Unit>> resetPassword(EmailAddress emailAddress);
}
