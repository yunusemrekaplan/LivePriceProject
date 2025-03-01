import 'package:get/get.dart';
import 'package:live_price_frontend/modules/auth/bindings/auth_binding.dart';
import 'package:live_price_frontend/modules/auth/views/login_view.dart';
import 'package:live_price_frontend/modules/customers/bindings/customers_binding.dart';
import 'package:live_price_frontend/modules/customers/views/customers_view.dart';
import 'package:live_price_frontend/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:live_price_frontend/modules/dashboard/views/dashboard_view.dart';
import 'package:live_price_frontend/modules/parities/bindings/parities_binding.dart';
import 'package:live_price_frontend/modules/parities/views/parities_view.dart';
import 'package:live_price_frontend/modules/parity_groups/bindings/parity_groups_binding.dart';
import 'package:live_price_frontend/modules/parity_groups/views/parity_groups_view.dart';
import 'package:live_price_frontend/modules/users/bindings/users_binding.dart';
import 'package:live_price_frontend/modules/users/views/users_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      children: [
        GetPage(
          name: Routes.parities,
          page: () => const ParitiesView(),
          binding: ParitiesBinding(),
        ),
        GetPage(
          name: Routes.parityGroups,
          page: () => const ParityGroupsView(),
          binding: ParityGroupsBinding(),
        ),
        GetPage(
          name: Routes.users,
          page: () => const UsersView(),
          binding: UsersBinding(),
        ),
        GetPage(
          name: Routes.customers,
          page: () => const CustomersView(),
          binding: CustomersBinding(),
        ),
      ],
    ),
  ];
}
