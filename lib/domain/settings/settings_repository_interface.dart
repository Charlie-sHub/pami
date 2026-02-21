import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/settings.dart';
import 'package:pami/domain/core/failures/app_failure.dart';

/// Interface for the settings repository
abstract class SettingsRepositoryInterface {
  /// Fetches the user's settings
  Future<Either<AppFailure, Settings>> fetchUserSettings();

  /// Updates the user's settings
  Future<Either<AppFailure, Unit>> updateUserSettings(Settings settings);
}
