class Pair {
  int? id;
  String? name;
  String? symbol;
  int? orderIndex;
  String? groupName;
  int? groupId;
  int? groupOrderIndex;
  double? ask;
  double? bid;
  double? close;
  double? high;
  double? low;
  double? change;
  DateTime? updateTime;

  Pair({
    this.id,
    this.name,
    this.symbol,
    this.orderIndex,
    this.groupName,
    this.groupId,
    this.groupOrderIndex,
    this.ask,
    this.bid,
    this.close,
    this.high,
    this.low,
    this.change,
    this.updateTime,
  });

  // JSON'dan Pair nesnesine dönüştürme
  factory Pair.fromJson(Map<String, dynamic> json) {
    return Pair(
      id: json['id'] as int?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      orderIndex: json['orderIndex'] as int?,
      groupName: json['groupName'] as String?,
      groupId: json['groupId'] as int?,
      groupOrderIndex: json['groupOrderIndex'] as int?,
      ask: json['ask'] != null ? (json['ask'] as num).toDouble() : null,
      bid: json['bid'] != null ? (json['bid'] as num).toDouble() : null,
      close: json['close'] != null ? (json['close'] as num).toDouble() : null,
      high: json['high'] != null ? (json['high'] as num).toDouble() : null,
      low: json['low'] != null ? (json['low'] as num).toDouble() : null,
      change:
          json['change'] != null ? (json['change'] as num).toDouble() : null,
      updateTime: json['updateTime'] != null
          ? DateTime.tryParse(json['updateTime'].toString())
          : null,
    );
  }

  // Pair nesnesinden JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'orderIndex': orderIndex,
      'groupName': groupName,
      'groupId': groupId,
      'groupOrderIndex': groupOrderIndex,
      'ask': ask,
      'bid': bid,
      'close': close,
      'high': high,
      'low': low,
      'change': change,
      'updateTime': updateTime?.toIso8601String(),
    };
  }

  // Pair nesnesini Parity modeline dönüştür (UI kısmı için)
  Parity toParity() {
    return Parity(
      symbol: symbol ?? 'Bilinmiyor',
      buyPrice: bid ?? 0.0,
      sellPrice: ask ?? 0.0,
      changePercentage: change ?? 0.0,
      isIncreasing: change != null ? change! > 0 : false,
      updateTime: updateTime != null
          ? '${updateTime!.hour.toString().padLeft(2, '0')}:${updateTime!.minute.toString().padLeft(2, '0')}'
          : '--:--',
    );
  }

  // Pair nesnesini GoldItem modeline dönüştür (UI kısmı için)
  GoldItem toGoldItem() {
    return GoldItem(
      symbol: symbol ?? 'Bilinmiyor',
      buyPrice: bid ?? 0.0,
      sellPrice: ask ?? 0.0,
      changePercentage: change ?? 0.0,
      isIncreasing: change != null ? change! > 0 : false,
      updateTime: updateTime != null
          ? '${updateTime!.hour.toString().padLeft(2, '0')}:${updateTime!.minute.toString().padLeft(2, '0')}'
          : '--:--',
    );
  }
}

// Parity model sınıfı (UI için)
class Parity {
  final String symbol;
  final double buyPrice;
  final double sellPrice;
  final double changePercentage;
  final bool isIncreasing;
  final String updateTime;

  Parity({
    required this.symbol,
    required this.buyPrice,
    required this.sellPrice,
    required this.changePercentage,
    required this.isIncreasing,
    required this.updateTime,
  });
}

// GoldItem model sınıfı (UI için)
class GoldItem {
  final String symbol;
  final double buyPrice;
  final double sellPrice;
  final double changePercentage;
  final bool isIncreasing;
  final String updateTime;

  GoldItem({
    required this.symbol,
    required this.buyPrice,
    required this.sellPrice,
    required this.changePercentage,
    required this.isIncreasing,
    required this.updateTime,
  });
}
