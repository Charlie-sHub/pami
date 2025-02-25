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
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegistrationRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: TutorialRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: ShoutOutCreationRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: ProfileManagementRoute.page),
    AutoRoute(page: HelpAndSupportRoute.page),
  ];
}
