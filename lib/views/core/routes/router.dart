import 'package:auto_route/auto_route.dart';
import 'package:pami/views/core/routes/router.gr.dart';

/// App's router
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, path: '/'),
  ];
}
