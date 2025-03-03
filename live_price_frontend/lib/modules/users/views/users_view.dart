import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/layout/admin_layout.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/modules/users/controllers/users_controller.dart';
import 'package:live_price_frontend/modules/users/widgets/user_header.dart';
import 'package:live_price_frontend/modules/users/widgets/user_table.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Kullanıcılar',
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserHeader(),
            SizedBox(height: AppSizes.p24),
            UserTable(),
          ],
        ),
      ),
    );
  }
}
