class Parity {
  final String symbol;
  final double buyPrice;
  final double sellPrice;
  final double changePercentage;
  final String updateTime;
  final bool isIncreasing;

  Parity({
    required this.symbol,
    required this.buyPrice,
    required this.sellPrice,
    required this.changePercentage,
    required this.updateTime,
    required this.isIncreasing,
  });

  // Örnek veri oluşturma
  static List<Parity> getDummyData() {
    return [
      Parity(
        symbol: 'USDTRY',
        buyPrice: 36555.5000,
        sellPrice: 36555.7120,
        changePercentage: 0.0273,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      Parity(
        symbol: 'EURTRY',
        buyPrice: 39.5867,
        sellPrice: 39.9247,
        changePercentage: 0.416,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      Parity(
        symbol: 'GBPTRY',
        buyPrice: 47.3853,
        sellPrice: 47.4514,
        changePercentage: 0.0286,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      Parity(
        symbol: 'EURUSD',
        buyPrice: 1.0835,
        sellPrice: 1.0852,
        changePercentage: 0.4786,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      Parity(
        symbol: 'CHFTRY',
        buyPrice: 41.4492,
        sellPrice: 41.5064,
        changePercentage: 0.4938,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      Parity(
        symbol: 'AEDTRY',
        buyPrice: 9.9773,
        sellPrice: 9.9895,
        changePercentage: 0.3747,
        updateTime: '03:01',
        isIncreasing: true,
      ),
      Parity(
        symbol: 'AUDTRY',
        buyPrice: 23.1780,
        sellPrice: 23.2106,
        changePercentage: 0.3029,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      Parity(
        symbol: 'RUBTRY',
        buyPrice: 0.4272,
        sellPrice: 0.4273,
        changePercentage: 0.4113,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      Parity(
        symbol: 'RUBTRY',
        buyPrice: 0.4272,
        sellPrice: 0.4273,
        changePercentage: 0.4113,
        updateTime: '03:06',
        isIncreasing: true,
      ),
    ];
  }

  // Favoriler için örnek veri
  static List<Parity> getFavoritesData() {
    return [
      Parity(
        symbol: 'USDTRY',
        buyPrice: 36.5000,
        sellPrice: 36.7120,
        changePercentage: 0.0273,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      Parity(
        symbol: 'EURTRY',
        buyPrice: 39.5867,
        sellPrice: 39.9247,
        changePercentage: 0.416,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      Parity(
        symbol: 'GBPTRY',
        buyPrice: 47.3853,
        sellPrice: 47.4514,
        changePercentage: 0.0286,
        updateTime: '03:06',
        isIncreasing: true,
      ),
    ];
  }
}

class GoldItem {
  final String symbol;
  final double buyPrice;
  final double sellPrice;
  final double changePercentage;
  final String updateTime;
  final bool isIncreasing;

  GoldItem({
    required this.symbol,
    required this.buyPrice,
    required this.sellPrice,
    required this.changePercentage,
    required this.updateTime,
    required this.isIncreasing,
  });

  // Örnek altın verisi oluşturma
  static List<GoldItem> getDummyData() {
    return [
      GoldItem(
        symbol: 'HAS Altın',
        buyPrice: 3548.38,
        sellPrice: 3557.20,
        changePercentage: 0.36,
        updateTime: '23:59',
        isIncreasing: true,
      ),
      GoldItem(
        symbol: 'ONS Altın/USD',
        buyPrice: 2989.7,
        sellPrice: 2990.1,
        changePercentage: 0.2,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      GoldItem(
        symbol: 'ONS Altın/EUR',
        buyPrice: 2747.73,
        sellPrice: 2748.15,
        changePercentage: 0.18,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      GoldItem(
        symbol: 'Altın KG/USD',
        buyPrice: 96260.0,
        sellPrice: 96460.0,
        changePercentage: 0.0,
        updateTime: '23:59',
        isIncreasing: false,
      ),
      GoldItem(
        symbol: 'Altın KG/EUR',
        buyPrice: 88640.0,
        sellPrice: 88990.0,
        changePercentage: 0.0,
        updateTime: '23:59',
        isIncreasing: true,
      ),
      GoldItem(
        symbol: 'Gümüş',
        buyPrice: 33.770,
        sellPrice: 33.790,
        changePercentage: -0.03,
        updateTime: '23:59',
        isIncreasing: false,
      ),
      GoldItem(
        symbol: 'Altın/Gümüş Ratio',
        buyPrice: 88.47,
        sellPrice: 88.52,
        changePercentage: 0.15,
        updateTime: '03:06',
        isIncreasing: true,
      ),
      GoldItem(
        symbol: 'Çeyrek Yeni',
        buyPrice: 5748.38,
        sellPrice: 5808.91,
        changePercentage: 0.0,
        updateTime: '23:59',
        isIncreasing: true,
      ),
    ];
  }

  // Favoriler için örnek veri
  static List<GoldItem> getFavoritesData() {
    return [
      GoldItem(
        symbol: 'HAS Altın',
        buyPrice: 3548.38,
        sellPrice: 3557.20,
        changePercentage: 0.36,
        updateTime: '23:59',
        isIncreasing: true,
      ),
    ];
  }
}
