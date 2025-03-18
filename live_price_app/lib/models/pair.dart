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
      change: json['change'] != null ? (json['change'] as num).toDouble() : null,
      updateTime:
          json['updateTime'] != null ? DateTime.tryParse(json['updateTime'].toString()) : null,
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

  // UI için yardımcı getter metodları
  String get displaySymbol {
    if (groupId == 2) {
      return symbol ?? 'Bilinmiyor';
    } else {
      return name ?? 'Bilinmiyor';
    }
  }

  double get buyPrice => ask ?? 0.0;

  double get sellPrice => bid ?? 0.0;

  double get changePercentage => change ?? 0.0;

  bool get isIncreasing => change != null ? change! > 0 : false;

  String get displayUpdateTime => updateTime != null
      ? '${updateTime!.hour.toString().padLeft(2, '0')}:${updateTime!.minute.toString().padLeft(2, '0')}'
      : '--:--';
}
