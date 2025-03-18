import 'package:get/get.dart';
import '../models/pair.dart';
import '../services/signalr_service.dart';

class PairsController extends GetxController {
  static PairsController get to => Get.find();

  // Çekilmiş tüm pariteler
  final allPairs = <Pair>[].obs;

  // Döviz pariteleri (grupId = 2)
  final currencyPairs = <Pair>[].obs;

  // Altın pariteleri (grupId != 2)
  final goldPairs = <Pair>[].obs;

  // Yükleniyor göstergesi
  final isLoading = true.obs;

  // Favori pariteler
  List<Pair> get favorites => allPairs.take(4).toList();

  @override
  void onInit() {
    super.onInit();
    // SignalR servisinden mesajları dinle
    _listenToSignalRMessages();
  }

  // SignalR'dan gelen mesajları dinle
  void _listenToSignalRMessages() {
    SignalRService.to.messageStream.listen((data) {
      try {
        if (data is List) {
          _processPairsData(data);
        } else if (data is Map<String, dynamic>) {
          _processSinglePairData(data);
        }
      } catch (e) {
        print('Veri işlenirken hata oluştu: $e');
      }
    });
  }

  // Toplu parite verisi işleme
  void _processPairsData(List data) {
    try {
      // JSON verisinden Pair nesnelerine dönüştür
      final pairs = data
          .map((item) =>
              item is Map<String, dynamic> ? Pair.fromJson(item) : null)
          .where((pair) => pair != null)
          .cast<Pair>()
          .toList();

      if (pairs.isNotEmpty) {
        // Tüm parite verilerini güncelle
        allPairs.value = pairs;

        // Döviz ve altın paritelerini ayır
        _separatePairsByGroup();

        // Yükleme tamamlandı
        isLoading.value = false;
      }
    } catch (e) {
      print('Toplu veri işlenirken hata: $e');
    }
  }

  // Tek parite verisi işleme
  void _processSinglePairData(Map<String, dynamic> data) {
    try {
      final pair = Pair.fromJson(data);
      if (pair.id != null) {
        // Mevcut pariteler içinde bu ID'ye sahip olanı güncelle veya yenisini ekle
        final index = allPairs.indexWhere((item) => item.id == pair.id);

        if (index >= 0) {
          allPairs[index] = pair;
        } else {
          allPairs.add(pair);
        }

        // Grupları güncelle
        _separatePairsByGroup();

        // Yükleme tamamlandı
        isLoading.value = false;
      }
    } catch (e) {
      print('Tekil veri işlenirken hata: $e');
    }
  }

  // Pariteleri grupId'lerine göre ayır
  void _separatePairsByGroup() {
    // Döviz pariteleri (grupId = 2)
    currencyPairs.value = allPairs.where((pair) => pair.groupId == 2).toList();

    // Altın pariteleri (grupId != 2)
    goldPairs.value = allPairs
        .where((pair) => pair.groupId != null && pair.groupId != 2)
        .toList();
  }
}
