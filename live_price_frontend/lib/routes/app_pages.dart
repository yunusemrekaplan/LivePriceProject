import 'package:get/get.dart';
import 'package:live_price_frontend/core/middleware/auth_middleware.dart';
import 'package:live_price_frontend/core/middleware/layout_middleware.dart';
import 'package:live_price_frontend/modules/auth/bindings/auth_binding.dart';
import 'package:live_price_frontend/modules/auth/views/login_view.dart';
import 'package:live_price_frontend/modules/customers/bindings/customers_binding.dart';
import 'package:live_price_frontend/modules/customers/views/customers_view.dart';
import 'package:live_price_frontend/modules/customer_panel/bindings/customer_panel_binding.dart';
import 'package:live_price_frontend/modules/customer_panel/views/customer_parities_view.dart';
import 'package:live_price_frontend/modules/customer_panel/views/customer_parity_groups_view.dart';
import 'package:live_price_frontend/modules/parity_groups/bindings/parity_groups_binding.dart';
import 'package:live_price_frontend/modules/parity_groups/views/parity_groups_view.dart';
import 'package:live_price_frontend/modules/users/bindings/users_binding.dart';
import 'package:live_price_frontend/modules/users/views/users_view.dart';
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
      middlewares: [AuthMiddleware(), LayoutMiddleware()],
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
      middlewares: [AuthMiddleware(), LayoutMiddleware()],
    ),
    GetPage(
      name: Routes.parityGroups,
      page: () => const ParityGroupsView(),
      binding: ParityGroupsBinding(),
      middlewares: [AuthMiddleware(), LayoutMiddleware()],
    ),
    GetPage(
      name: Routes.customers,
      page: () => const CustomersView(),
      binding: CustomersBinding(),
      middlewares: [AuthMiddleware(), LayoutMiddleware()],
    ),
    GetPage(
      name: Routes.users,
      page: () => const UsersView(),
      binding: UsersBinding(),
      middlewares: [AuthMiddleware(), LayoutMiddleware()],
    ),
    GetPage(
      name: Routes.customerParities,
      page: () => const CustomerParitiesView(),
      binding: CustomerPanelBinding(),
      middlewares: [AuthMiddleware(), LayoutMiddleware()],
    ),
    GetPage(
      name: Routes.customerParityGroups,
      page: () => const CustomerParityGroupsView(),
      binding: CustomerPanelBinding(),
      middlewares: [AuthMiddleware(), LayoutMiddleware()],
    ),
  ];
}
