import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../models/pair.dart';

/// SignalR bağlantı servis sınıfı
class SignalRService extends GetxService {
  static SignalRService get to => Get.find();

  // Hub URL ve API Key
  String _baseUrl = '';
  String _apiKey = '';

  // Bağlantı durumunu izleyebilmek için RxBool
  final isConnected = false.obs;
  final isConnecting = false.obs;
  final connectionError = Rxn<String>();

  // Son alınan fiyat verisi
  final lastReceivedData = Rxn<dynamic>();

  // SignalR hub bağlantısı
  HubConnection? _hubConnection;

  // Fiyat güncellemeleri için stream controller
  final StreamController<dynamic> _messageController =
      StreamController<dynamic>.broadcast();

  // Sistem mesajları için stream controller
  final StreamController<String> _systemMessageController =
      StreamController<String>.broadcast();

  // Bağlantı durumu değişiklikleri için stream controller
  final StreamController<bool> _connectionStateController =
      StreamController<bool>.broadcast();

  // Yayın akışları
  Stream<dynamic> get messageStream => _messageController.stream;
  Stream<String> get systemMessageStream => _systemMessageController.stream;
  Stream<bool> get connectionStateStream => _connectionStateController.stream;

  /// SignalR bağlantısını başlatır
  Future<void> initConnection(String baseUrl, String apiKey) async {
    if (isConnecting.value) return;

    _baseUrl = baseUrl;
    _apiKey = apiKey;

    isConnecting.value = true;
    connectionError.value = null;

    try {
      await _disposeCurrentConnection();

      final hubUrl = '$baseUrl/parityhub?apiKey=$apiKey';
      print('SignalR Hub URL: $hubUrl');

      final httpConnectionOptions = HttpConnectionOptions(
        logger: Logger('SignalR'),
        logMessageContent: true,
        skipNegotiation: true,
        transport: HttpTransportType.WebSockets,
      );

      _hubConnection = HubConnectionBuilder()
          .withUrl(hubUrl, options: httpConnectionOptions)
          .withAutomaticReconnect(retryDelays: [0, 2000, 5000, 10000, 30000])
          .configureLogging(Logger('SignalR-Client'))
          .build();

      _hubConnection!.onreconnecting(({error}) {
        print('SignalR bağlantısı yeniden kuruluyor... Hata: $error');
        isConnected.value = false;
        _connectionStateController.add(false);
        _systemMessageController.add('Bağlantı yeniden kuruluyor...');
      });

      _hubConnection!.onreconnected(({connectionId}) {
        print('SignalR bağlantısı yeniden kuruldu: $connectionId');
        isConnected.value = true;
        _connectionStateController.add(true);
        _systemMessageController.add('Bağlantı yeniden kuruldu');
      });

      _hubConnection!.onclose(({error}) {
        print('SignalR bağlantısı kapandı. Hata: $error');
        isConnected.value = false;
        _connectionStateController.add(false);
        if (error != null) {
          connectionError.value = error.toString();
          _systemMessageController.add('Bağlantı hatası: $error');
        }
      });

      _registerHubHandlers();

      await _hubConnection!.start();
      print('SignalR bağlantısı başlatıldı.');
      isConnected.value = true;
      _connectionStateController.add(true);
      _systemMessageController.add('Bağlantı başarıyla kuruldu');
    } catch (e) {
      print('SignalR bağlantı hatası: $e');
      connectionError.value = e.toString();
      isConnected.value = false;
      _connectionStateController.add(false);
      _systemMessageController.add('Bağlantı hatası: $e');
    } finally {
      isConnecting.value = false;
    }
  }

  /// Bağlantıyı yeniden başlatır
  Future<void> reconnect() async {
    if (_baseUrl.isNotEmpty && _apiKey.isNotEmpty) {
      await initConnection(_baseUrl, _apiKey);
    } else {
      print('Bağlantı yenilenemedi: baseUrl veya apiKey eksik');
      _systemMessageController.add('Bağlantı yenilenemedi: Ayarlar eksik');
    }
  }

  void _registerHubHandlers() {
    if (_hubConnection == null) return;

    // ReceiveParities metodunu dinle - Toplu parite verisi için
    _hubConnection!.on('ReceiveParities', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments.first;
        print('=================== PARİTE VERİLERİ ===================');
        print('Zaman: ${DateTime.now()}');
        print('Veri Tipi: ${data.runtimeType}');
        print('Veri İçeriği:');
        print(data);
        print('====================================================');

        lastReceivedData.value = data;
        _messageController.add(data);
      }
    });

    // ReceiveMessage metodunu dinle - Tekil parite güncellemeleri için
    _hubConnection!.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments.first;
        print('------------------ PARİTE GÜNCELLEMESİ ------------------');
        print('Zaman: ${DateTime.now()}');
        print('Veri Tipi: ${data.runtimeType}');
        print('Veri İçeriği:');
        print(data);
        print('------------------------------------------------------');

        lastReceivedData.value = data;
        _messageController.add(data);
      }
    });

    // Sistem mesajlarını dinle
    _hubConnection!.on('SystemMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final message = arguments.first.toString();
        print('🔔 Sistem Mesajı: $message');
        _systemMessageController.add(message);
      }
    });
  }

  /// Bağlantıyı kapatır
  Future<void> closeConnection() async {
    print('SignalR bağlantısı kapatılıyor...');
    await _disposeCurrentConnection();
    _systemMessageController.add('Bağlantı kapatıldı');
  }

  /// Servisi kapat
  @override
  void onClose() {
    _disposeCurrentConnection();

    _messageController.close();
    _systemMessageController.close();
    _connectionStateController.close();

    super.onClose();
  }

  /// Mevcut bağlantıyı temizle
  Future<void> _disposeCurrentConnection() async {
    if (_hubConnection != null) {
      try {
        await _hubConnection!.stop();
      } catch (e) {
        print('SignalR bağlantısını kapatırken hata: $e');
      }
      _hubConnection = null;
    }
    isConnected.value = false;
  }
}
