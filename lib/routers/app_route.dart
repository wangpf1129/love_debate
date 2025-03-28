import 'package:auto_route/auto_route.dart';
import 'package:love_debate/routers/app_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: ListRoute.page),
        AutoRoute(page: MatchRoute.page),
        AutoRoute(page: CreateRoute.page),
        AutoRoute(page: DetailRoute.page),
        AutoRoute(page: ResultRoute.page),
      ];
}
