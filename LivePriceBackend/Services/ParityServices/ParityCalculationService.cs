using LivePriceBackend.Constants.Enums;
using LivePriceBackend.Entities;

namespace LivePriceBackend.Services.ParityServices;

public interface IParityCalculationService
{
    (decimal Ask, decimal Bid) ApplySpread(decimal rawAsk, decimal rawBid, CParityRule parityRule);
    (decimal Ask, decimal Bid) ApplySpread(decimal rawAsk, decimal rawBid, Parity parity);
    decimal CalculateChangeRate(decimal currentBid, decimal closePrice);
    decimal RoundPrice(decimal price, int scale);
}

public class ParityCalculationService : IParityCalculationService
{
    private readonly ILogger<ParityCalculationService> _logger;

    public ParityCalculationService(ILogger<ParityCalculationService> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Müşteri kurallarına göre ham fiyatlara spread uygular
    /// </summary>
    /// <param name="rawAsk">Ham satış fiyatı</param>
    /// <param name="rawBid">Ham alış fiyatı</param>
    /// <param name="parityRule">Müşteri parite kuralı</param>
    /// <returns>Spread uygulanmış (Ask, Bid) ikilisi</returns>
    public (decimal Ask, decimal Bid) ApplySpread(decimal rawAsk, decimal rawBid, CParityRule parityRule)
    {
        decimal ask = rawAsk;
        decimal bid = rawBid;

        // Eğer spread kuralı yoksa, ham değerleri döndür
        if (parityRule?.SpreadRuleType == null)
        {
            return (ask, bid);
        }

        var askSpread = parityRule.SpreadForAsk ?? 0;
        var bidSpread = parityRule.SpreadForBid ?? 0;

        try
        {
            switch (parityRule.SpreadRuleType.Value)
            {
                case SpreadRuleType.Percentage:
                    // Yüzdelik spread: Ask'a eklenir, Bid'den çıkarılır
                    ask = ask * (1 + askSpread / 100);
                    bid = bid * (1 + bidSpread / 100);
                    _logger.LogDebug("Yüzde spread uygulandı: {ParityId}, Ask: {AskSpread}%, Bid: {BidSpread}%, Sonuç: ({Ask}, {Bid})",
                        parityRule.ParityId, askSpread, bidSpread, ask, bid);
                    break;

                case SpreadRuleType.Fixed:
                    // Sabit spread: Ask'a eklenir, Bid'den çıkarılır
                    ask = ask + askSpread;
                    bid = bid + bidSpread;
                    _logger.LogDebug("Sabit spread uygulandı: {ParityId}, Ask: +{AskSpread}, Bid: -{BidSpread}, Sonuç: ({Ask}, {Bid})",
                        parityRule.ParityId, askSpread, bidSpread, ask, bid);
                    break;

                default:
                    _logger.LogWarning("Bilinmeyen spread kuralı: {RuleType}", parityRule.SpreadRuleType);
                    break;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Spread hesaplaması sırasında hata: Parite {ParityId}, Rule {RuleId}", 
                parityRule.ParityId, parityRule.Id);
            // Hata durumunda ham değerleri döndür
            return (rawAsk, rawBid);
        }

        return (ask, bid);
    }

    /// <summary>
    /// Parite için varsayılan spread kurallarına göre ham fiyatlara spread uygular
    /// </summary>
    /// <param name="rawAsk">Ham satış fiyatı</param>
    /// <param name="rawBid">Ham alış fiyatı</param>
    /// <param name="parity">Parite</param>
    /// <returns>Spread uygulanmış (Ask, Bid) ikilisi</returns>
    public (decimal Ask, decimal Bid) ApplySpread(decimal rawAsk, decimal rawBid, Parity parity)
    {
        decimal ask = rawAsk;
        decimal bid = rawBid;

        // Eğer spread kuralı yoksa, ham değerleri döndür
        if (parity?.SpreadRuleType == null)
        {
            return (ask, bid);
        }

        var askSpread = parity.SpreadForAsk ?? 0;
        var bidSpread = parity.SpreadForBid ?? 0;

        try
        {
            switch (parity.SpreadRuleType.Value)
            {
                case SpreadRuleType.Percentage:
                    // Yüzdelik spread: Ask'a eklenir, Bid'den çıkarılır
                    ask = ask * (1 + askSpread / 100);
                    bid = bid * (1 + bidSpread / 100);
                    _logger.LogDebug("Yüzde spread uygulandı: {ParityId}, Ask: {AskSpread}%, Bid: {BidSpread}%, Sonuç: ({Ask}, {Bid})",
                        parity.Id, askSpread, bidSpread, ask, bid);
                    break;

                case SpreadRuleType.Fixed:
                    // Sabit spread: Ask'a eklenir, Bid'den çıkarılır
                    ask = ask + askSpread;
                    bid = bid + bidSpread;
                    _logger.LogDebug("Sabit spread uygulandı: {ParityId}, Ask: +{AskSpread}, Bid: -{BidSpread}, Sonuç: ({Ask}, {Bid})",
                        parity.Id, askSpread, bidSpread, ask, bid);
                    break;

                default:
                    _logger.LogWarning("Bilinmeyen spread kuralı: {RuleType}", parity.SpreadRuleType);
                    break;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Spread hesaplaması sırasında hata: Parite {ParityId}", parity.Id);
            // Hata durumunda ham değerleri döndür
            return (rawAsk, rawBid);
        }

        return (ask, bid);
    }

    /// <summary>
    /// Kapanış fiyatına göre değişim oranını yüzde olarak hesaplar
    /// </summary>
    /// <param name="currentBid">Şu anki alış fiyatı</param>
    /// <param name="closePrice">Kapanış fiyatı</param>
    /// <returns>Yüzde değişim oranı</returns>
    public decimal CalculateChangeRate(decimal currentBid, decimal closePrice)
    {
        if (closePrice <= 0)
        {
            return 0;
        }

        try
        {
            return (decimal)Math.Round(((double)currentBid - (double)closePrice) / (double)closePrice * 100, 2);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Değişim oranı hesaplanırken hata: Bid={Bid}, Close={Close}", currentBid, closePrice);
            return 0;
        }
    }

    /// <summary>
    /// Fiyatı belirtilen ondalık basamak sayısına yuvarlar
    /// </summary>
    /// <param name="price">Yuvarlanacak fiyat</param>
    /// <param name="scale">Ondalık basamak sayısı</param>
    /// <returns>Yuvarlanmış fiyat</returns>
    public decimal RoundPrice(decimal price, int scale)
    {
        // Scale 0 veya negatifse, tamsayıya yuvarla
        if (scale <= 0)
        {
            return Math.Round(price, 0);
        }

        // Maksimum 28 ondalık basamak destekleniyor (decimal için limit)
        if (scale > 28)
        {
            scale = 28;
        }

        return Math.Round(price, scale);
    }
} 