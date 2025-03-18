import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/theme.dart';
import 'views/screens/home_screen.dart';
import 'app/app_bindings.dart';
import 'services/signalr_service.dart';

// API ve bağlantı bilgileri
const String apiKey = '91e8bf92b77f4101ac6d752da8c59329';
const String apiBaseUrl = 'http://192.168.1.107:5104';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bağımlılıkları başlat
  AppBindings().dependencies();

  // SignalR bağlantısını başlat
  await SignalRService.to.initConnection(apiBaseUrl, apiKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Canlı Fiyat',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      initialBinding: AppBindings(),
      defaultTransition: Transition.fade,
    );
  }
}
