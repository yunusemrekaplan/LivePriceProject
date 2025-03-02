import 'package:get/get.dart';
import 'package:live_price_frontend/core/middleware/auth_middleware.dart';
import 'package:live_price_frontend/modules/auth/bindings/auth_binding.dart';
import 'package:live_price_frontend/modules/auth/views/login_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/parities/bindings/parities_binding.dart';
import '../modules/parities/views/parities_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.parities,
      page: () => const ParitiesView(),
      binding: ParitiesBinding(),
      middlewares: [AuthMiddleware()],
    ),
    /*GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
      children: [
        // Alt route'lar da auth middleware'i kullanacak
        GetPage(
          name: Routes.parities,
          page: () => const ParitiesView(),
          binding: ParitiesBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: Routes.parityGroups,
          page: () => const ParityGroupsView(),
          binding: ParityGroupsBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: Routes.users,
          page: () => const UsersView(),
          binding: UsersBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: Routes.customers,
          page: () => const CustomersView(),
          binding: CustomersBinding(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    ),*/
  ];
}
