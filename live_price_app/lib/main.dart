import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_app/services/signalr_service.dart';

const String apiKey = "91e8bf92b77f4101ac6d752da8c59329";
// Örnek: const String apiBaseUrl = "https://api.liveprice.app";
const String apiBaseUrl =
    "http://192.168.1.107:5104"; // Kendi IP adresinizi buraya yazın

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await initServices();

  runApp(const MyApp());
}

Future<void> initServices() async {
  // SignalR servisini başlat
  await Get.putAsync(() async {
    final service = SignalRService();
    return service;
  });

  // API bağlantısı kur
  await connectToLivePriceService();
}

Future<void> connectToLivePriceService() async {
  try {
    final signalRService = Get.find<SignalRService>();
    await signalRService.initConnection(apiBaseUrl, apiKey);
    print('Live Price servisine bağlantı başarılı');
  } catch (e) {
    print('Live Price servisine bağlantı sırasında hata: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Live Price App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PriceHomePage(),
    );
  }
}

class PriceHomePage extends StatelessWidget {
  const PriceHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final signalRService = Get.find<SignalRService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Döviz ve Altın Fiyatları'),
        actions: [
          // Bağlantı durumu göstergesi
          Obx(() {
            final isConnected = signalRService.isConnected.value;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isConnected ? Icons.cloud_done : Icons.cloud_off,
                color: isConnected ? Colors.green : Colors.red,
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // Bağlantı durumu banner'ı
          Obx(() {
            final isConnected = signalRService.isConnected.value;
            final isConnecting = signalRService.isConnecting.value;
            final error = signalRService.connectionError.value;

            if (!isConnected || isConnecting || error != null) {
              return Container(
                padding: const EdgeInsets.all(8),
                color:
                    isConnecting ? Colors.orange.shade100 : Colors.red.shade100,
                child: Row(
                  children: [
                    Icon(
                      isConnecting ? Icons.sync : Icons.error,
                      color: isConnecting ? Colors.orange : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isConnecting
                            ? 'Sunucuya bağlanıyor...'
                            : error ?? 'Bağlantı kesildi',
                        style: TextStyle(
                          color: isConnecting
                              ? Colors.orange.shade900
                              : Colors.red.shade900,
                        ),
                      ),
                    ),
                    if (!isConnecting)
                      TextButton(
                        onPressed: connectToLivePriceService,
                        child: const Text('Yeniden Bağlan'),
                      ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Sistem mesajları
          Container(
            padding: const EdgeInsets.all(8),
            child: StreamBuilder<String>(
              stream: signalRService.systemMessageStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return Text(
                  snapshot.data!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                );
              },
            ),
          ),

          // Fiyat verileri
          Expanded(
            child: StreamBuilder<dynamic>(
              stream: signalRService.messageStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Fiyat verileri bekleniyor...'),
                      ],
                    ),
                  );
                }

                final data = snapshot.data;

                // Gelen veriyi göster
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Son Alınan Veri:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            data.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
