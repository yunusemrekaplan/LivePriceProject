import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_theme.dart';
import 'package:live_price_frontend/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Live Price Admin',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
