import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/injection.config.dart';

/// Instance of [GetIt]
final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)

/// Configures the dependency injection container
void configureDependencies(String env) => getIt.init(environment: env);
