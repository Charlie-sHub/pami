import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Interface for the settings repository
abstract class SettingsRepositoryInterface {
  /// Fetches the user's settings
  Future<Either<Failure, Settings>> fetchUserSettings();

  /// Updates the user's settings
  Future<Either<Failure, Unit>> updateUserSettings(Settings settings);
}
