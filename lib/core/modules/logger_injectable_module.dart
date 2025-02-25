import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// Logger Injectable Module
@module
abstract class LoggerInjectableModule {
  /// Singleton instance of Logger
  @lazySingleton
  Logger get logger => Logger();
}
