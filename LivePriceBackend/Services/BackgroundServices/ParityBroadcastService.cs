using LivePriceBackend.Exceptions;
using LivePriceBackend.Services.Caching;
using LivePriceBackend.Services.Hubs;
using LivePriceBackend.Services.ParityServices;
using Microsoft.AspNetCore.SignalR;
using System.Diagnostics;
using LivePriceBackend.DTOs.Service;

namespace LivePriceBackend.Services.BackgroundServices;

public class ParityBroadcastService(
    IServiceProvider serviceProvider,
    IHubContext<ParityHub> hubContext,
    ILogger<ParityBroadcastService> logger,
    ConnectionTracker connectionTracker,
    ParityCache parityCache,
    IParityCalculationService calculationService)
    : BackgroundService
{
    private readonly TimeSpan _interval = TimeSpan.FromSeconds(3); // 3 saniyede bir güncelleme

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        logger.LogInformation("Parite Yayın Servisi başlatıldı");

        using var timer = new PeriodicTimer(_interval);

        while (await timer.WaitForNextTickAsync(stoppingToken))
        {
            try
            {
                var stopwatch = Stopwatch.StartNew();

                await FetchAndBroadcastParitiesAsync(stoppingToken);

                stopwatch.Stop();
                // Sadece uzun süren işlemleri logla
                if (stopwatch.ElapsedMilliseconds > 1000)
                {
                    logger.LogWarning("Parite yayını uzun sürdü: {ElapsedMs}ms", stopwatch.ElapsedMilliseconds);
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Parite yayını sırasında kritik hata oluştu");
                await NotifySystemErrorAsync("Parite yayın servisi hatası: " + ex.Message);
            }
        }
    }

    private async Task FetchAndBroadcastParitiesAsync(CancellationToken stoppingToken)
    {
        try
        {
            // Aktif bağlantısı olan müşteri yoksa işlem yapma
            var connectedCustomerIds = connectionTracker.GetConnectedCustomerIds().ToList();
            if (connectedCustomerIds.Count == 0)
                return; // Hiç bağlı müşteri yok

            // Cache'den verileri al
            var dbParities = await parityCache.GetParitiesAsync();
            var customerParityRules = await parityCache.GetParityRulesAsync(connectedCustomerIds);
            var customerGroupRules = await parityCache.GetGroupRulesAsync(connectedCustomerIds);

            // Pariteleri market kodlarına göre gruplandır
            var marketGroups = dbParities
                .GroupBy(p => p.RawMarketCode)
                .ToDictionary(g => g.Key, g => g.Select(p => p.RawSymbol).Distinct().ToArray());

            if (marketGroups.Count == 0)
                return; // Hiç market yok

            logger.LogInformation("Toplam {MarketCount} farklı market için veri çekilecek", marketGroups.Count);

            // XmlParityService'den ham verileri çek
            using var scope = serviceProvider.CreateScope();
            var xmlParityService = scope.ServiceProvider.GetRequiredService<IXmlParityService>();

            List<ParityHamData> hamParities = new();
            foreach (var (marketCode, symbols) in marketGroups)
            {
                if (symbols.Length == 0)
                    continue;

                logger.LogInformation("Market {MarketCode} için {SymbolCount} sembol çekiliyor", marketCode, symbols.Length);

                try
                {
                    // Market kodu ve semboller ile veri çek
                    var marketParities = await xmlParityService.GetByMarketAndSymbolsAsync(marketCode, symbols, stoppingToken);
                    hamParities.AddRange(marketParities);
                }
                catch (ExternalServiceException ex)
                {
                    logger.LogError(ex, "Market {MarketCode} için veri çekme hatası: {Message}", marketCode, ex.Message);
                    // Hata durumunda diğer marketlerle devam et
                }
            }

            if (hamParities.Count == 0)
            {
                logger.LogWarning("Hiçbir marketten veri çekilemedi");
                await NotifyCustomersAsync("VeriYok", "Parite verisi bulunamadı", stoppingToken);
                return;
            }

            // Her bağlı müşteri için pariteleri hazırla ve gönder
            var successfulSendCount = 0;
            var errorCount = 0;

            foreach (var customerId in connectedCustomerIds)
            {
                if (!connectionTracker.HasConnections(customerId))
                    continue;

                try
                {
                    var customerRules = customerParityRules
                        .Where(r => r.CustomerId == customerId)
                        .ToList();

                    // Müşterinin görünmez olarak işaretlediği grupları bul
                    var invisibleGroups = customerGroupRules
                        .Where(r => r.CustomerId == customerId && !r.IsVisible)
                        .Select(r => r.ParityGroupId)
                        .ToHashSet();

                    var customerParities = new List<object>();

                    foreach (var dbParity in dbParities)
                    {
                        try
                        {
                            // Eğer grup için kural yoksa veya IsVisible=true ise göster
                            if (invisibleGroups.Contains(dbParity.ParityGroupId))
                                continue;

                            // Parite kural kontrolü - görünürlük ve spread
                            var parityRule = customerRules.FirstOrDefault(r => r.ParityId == dbParity.Id);
                            if (parityRule is { IsVisible: false })
                                continue;

                            // Dış servisten gelen veriyi bul
                            var hamData = hamParities.FirstOrDefault(h => h.Symbol == dbParity.RawSymbol);
                            if (hamData == null)
                                continue; // Parite verisi bulunamadı

                            // Önce DB'deki default spread değerlerini uygula
                            var (defaultAsk, defaultBid) = calculationService.ApplySpread(
                                hamData.Ask ?? 0,
                                hamData.Bid ?? 0,
                                dbParity);

                            var (defaultHigh, _) = calculationService.ApplySpread(
                                hamData.High ?? 0,
                                hamData.High ?? 0,
                                dbParity);

                            var (defaultLow, _) = calculationService.ApplySpread(
                                hamData.Low ?? 0,
                                hamData.Low ?? 0,
                                dbParity);

                            var (defaultClose, _) = calculationService.ApplySpread(
                                hamData.Close ?? 0,
                                hamData.Close ?? 0,
                                dbParity);

                            // Eğer müşteri kuralı varsa, müşteri spread'ini uygula
                            var (finalAsk, finalBid) =
                                parityRule != null && (parityRule.SpreadForAsk.HasValue || parityRule.SpreadForBid.HasValue)
                                    ? calculationService.ApplySpread(defaultAsk, defaultBid, parityRule)
                                    : (defaultAsk, defaultBid);

                            var (finalHigh, _) =
                                parityRule != null && (parityRule.SpreadForAsk.HasValue || parityRule.SpreadForBid.HasValue)
                                    ? calculationService.ApplySpread(defaultHigh, defaultHigh, parityRule)
                                    : (defaultHigh, defaultHigh);

                            var (finalLow, _) =
                                parityRule != null && (parityRule.SpreadForAsk.HasValue || parityRule.SpreadForBid.HasValue)
                                    ? calculationService.ApplySpread(defaultLow, defaultLow, parityRule)
                                    : (defaultLow, defaultLow);

                            var (finalClose, _) =
                                parityRule != null && (parityRule.SpreadForAsk.HasValue || parityRule.SpreadForBid.HasValue)
                                    ? calculationService.ApplySpread(defaultClose, defaultClose, parityRule)
                                    : (defaultClose, defaultClose);

                            // Değişim oranını hesapla
                            var change = hamData.DailyChange ?? calculationService.CalculateChangeRate(finalBid, finalClose);

                            // Scale değerini doğrula ve uygula
                            var scale = dbParity.Scale < 0 ? 4 : dbParity.Scale; // Varsayılan 4 ondalık hane

                            customerParities.Add(new ParityData
                            {
                                Id = dbParity.Id,
                                Name = dbParity.Name,
                                Symbol = dbParity.Symbol,
                                OrderIndex = dbParity.OrderIndex,
                                GroupName = dbParity.ParityGroup.Name,
                                GroupId = dbParity.ParityGroupId,
                                GroupOrderIndex = dbParity.ParityGroup.OrderIndex,
                                Ask = calculationService.RoundPrice(finalAsk, scale),
                                Bid = calculationService.RoundPrice(finalBid, scale),
                                Close = calculationService.RoundPrice(finalClose, scale),
                                High = calculationService.RoundPrice(finalHigh, scale),
                                Low = calculationService.RoundPrice(finalLow, scale),
                                Change = change,
                                UpdateTime = DateTime.UtcNow
                            });
                        }
                        catch
                        {
                            logger.LogWarning("Parite işleme hatası: {ParityName}", dbParity.Name);
                        }
                    }

                    if (customerParities.Count != 0)
                    {
                        await hubContext.Clients
                            .Group($"customer_{customerId}")
                            .SendAsync("ReceiveParities", customerParities, stoppingToken);

                        successfulSendCount++;
                    }
                    else
                    {
                        // Hiç parite bulunamadığında müşteriye bildirim gönder
                        await hubContext.Clients
                            .Group($"customer_{customerId}")
                            .SendAsync("SystemMessage", "Görüntülenecek parite bulunamadı. Lütfen parite ayarlarınızı kontrol ediniz.",
                                stoppingToken);
                    }
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "Müşteri {CustomerId} için parite işleme hatası", customerId);
                    errorCount++;
                }
            }

            // Sadece hata olduğunda logla
            if (errorCount > 0)
            {
                logger.LogWarning(
                    "Parite yayınında hatalar oluştu. Başarılı: {SuccessCount}, Hata: {ErrorCount}",
                    successfulSendCount, errorCount);
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Parite yayını hazırlama sırasında hata oluştu");
            await NotifySystemErrorAsync("Parite verisi hazırlama hatası: " + ex.Message);
        }
    }

    /// <summary>
    /// Tüm bağlı müşterilere sistem mesajı gönderir
    /// </summary>
    private async Task NotifyCustomersAsync(string eventType, string message, CancellationToken cancellationToken)
    {
        try
        {
            await hubContext.Clients.All.SendAsync("SystemMessage",
                new { Type = eventType, Message = message }, cancellationToken);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Sistem mesajı gönderme hatası");
        }
    }

    /// <summary>
    /// Sistem hata durumlarında loglama ve bildirim
    /// </summary>
    private async Task NotifySystemErrorAsync(string errorMessage)
    {
        try
        {
            logger.LogCritical("SİSTEM HATASI: {ErrorMessage}", errorMessage);

            // Tüm bağlı müşterilere bilgi mesajı gönderilir
            await hubContext.Clients.All.SendAsync("SystemMessage",
                "Şu anda teknik bir sorun yaşanmaktadır. Kısa süre içinde düzelecektir.");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Sistem hatası bildirimi yapılırken ikincil hata oluştu");
        }
    }
}