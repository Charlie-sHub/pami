import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/settings.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/settings/settings_repository_interface.dart';

// coverage:ignore-files
/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: SettingsRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentSettingsRepository implements SettingsRepositoryInterface {
  /// Default constructor
  DevelopmentSettingsRepository(this._logger);

  final Logger _logger;

  @override
  Future<Either<Failure, Settings>> fetchUserSettings() async {
    _logger.d('Fetching user settings...');
    final settings = getValidSettings();
    _logger.d('Returning mock settings');
    return right(settings);
  }

  @override
  Future<Either<Failure, Unit>> updateUserSettings(Settings settings) async {
    _logger.d('Updating user settings...');
    return right(unit);
  }
}
