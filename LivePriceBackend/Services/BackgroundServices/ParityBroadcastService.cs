using LivePriceBackend.Entities;
using LivePriceBackend.Exceptions;
using LivePriceBackend.Services.Caching;
using LivePriceBackend.Services.Hubs;
using LivePriceBackend.Services.ParityServices;
using Microsoft.AspNetCore.SignalR;
using System.Diagnostics;

namespace LivePriceBackend.Services.BackgroundServices;

public class ParityBroadcastService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly IHubContext<ParityHub> _hubContext;
    private readonly ILogger<ParityBroadcastService> _logger;
    private readonly ConnectionTracker _connectionTracker;
    private readonly ParityCache _parityCache;
    private readonly IParityCalculationService _calculationService;
    private readonly TimeSpan _interval = TimeSpan.FromSeconds(3); // 3 saniyede bir güncelleme

    public ParityBroadcastService(
        IServiceProvider serviceProvider,
        IHubContext<ParityHub> hubContext,
        ILogger<ParityBroadcastService> logger,
        ConnectionTracker connectionTracker,
        ParityCache parityCache,
        IParityCalculationService calculationService)
    {
        _serviceProvider = serviceProvider;
        _hubContext = hubContext;
        _logger = logger;
        _connectionTracker = connectionTracker;
        _parityCache = parityCache;
        _calculationService = calculationService;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Parite Yayın Servisi başlatıldı");

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
                    _logger.LogWarning("Parite yayını uzun sürdü: {ElapsedMs}ms", stopwatch.ElapsedMilliseconds);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Parite yayını sırasında kritik hata oluştu");
                await NotifySystemErrorAsync("Parite yayın servisi hatası: " + ex.Message);
            }
        }
    }

    private async Task FetchAndBroadcastParitiesAsync(CancellationToken stoppingToken)
    {
        try
        {
            // Aktif bağlantısı olan müşteri yoksa işlem yapma
            var connectedCustomerIds = _connectionTracker.GetConnectedCustomerIds().ToList();
            if (connectedCustomerIds.Count == 0)
            {
                return;
            }

            // HaremService'den ham verileri çek
            using var scope = _serviceProvider.CreateScope();
            var haremService = scope.ServiceProvider.GetRequiredService<IHaremService>();
            
            List<ParityHamData> hamParities;
            try
            {
                hamParities = await haremService.GetAllAsync() ?? new List<ParityHamData>();
                
                // Sadece veri çekilemediğinde logla
                if (hamParities.Count == 0)
                {
                    _logger.LogWarning("HaremService'den veri alınamadı");
                }
            }
            catch (ExternalServiceException ex)
            {
                _logger.LogError(ex, "HaremService veri çekme hatası: {Message}", ex.Message);
                await NotifyCustomersAsync("VeriKaynağıHatası", "Dış servis veri kaynağı hatası", stoppingToken);
                return;
            }
            
            if (!hamParities.Any())
            {
                await NotifyCustomersAsync("VeriYok", "Parite verisi bulunamadı", stoppingToken);
                return;
            }

            // Cache'den verileri al
            var dbParities = await _parityCache.GetParitiesAsync();
            var customerParityRules = await _parityCache.GetParityRulesAsync(connectedCustomerIds);
            var customerGroupRules = await _parityCache.GetGroupRulesAsync(connectedCustomerIds);

            // Her bağlı müşteri için pariteleri hazırla ve gönder
            int successfulSendCount = 0;
            int errorCount = 0;
            
            foreach (var customerId in connectedCustomerIds)
            {
                if (!_connectionTracker.HasConnections(customerId))
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
                            if (parityRule == null || !parityRule.IsVisible)
                                continue;

                            // Dış servisten gelen veriyi bul
                            var hamData = hamParities.FirstOrDefault(h => h.Symbol == dbParity.RawSymbol);
                            if (hamData == null)
                                continue;

                            // Spread hesaplama servisini kullanarak fiyatları hesapla
                            var (ask, bid) = _calculationService.ApplySpread(hamData.Ask, hamData.Bid, parityRule);
                            
                            // Değişim oranını hesapla
                            var change = _calculationService.CalculateChangeRate(bid, hamData.Close);

                            // Scale değerini doğrula ve uygula
                            int scale = dbParity.Scale < 0 ? 4 : dbParity.Scale; // Varsayılan 4 ondalık hane

                            customerParities.Add(new
                            {
                                Symbol = dbParity.Symbol,
                                Ask = _calculationService.RoundPrice(ask, scale),
                                Bid = _calculationService.RoundPrice(bid, scale),
                                GroupName = dbParity.ParityGroup?.Name,
                                GroupId = dbParity.ParityGroupId,
                                Change = change,
                                UpdateTime = DateTime.UtcNow
                            });
                        }
                        catch
                        {
                            // Tek bir parite hatası için loglama yapmıyoruz
                            continue;
                        }
                    }

                    if (customerParities.Any())
                    {
                        await _hubContext.Clients
                            .Group($"customer_{customerId}")
                            .SendAsync("ReceiveParities", customerParities, stoppingToken);
                            
                        successfulSendCount++;
                    }
                    else
                    {
                        // Hiç parite bulunamadığında müşteriye bildirim gönder
                        await _hubContext.Clients
                            .Group($"customer_{customerId}")
                            .SendAsync("SystemMessage", "Görüntülenecek parite bulunamadı. Lütfen parite ayarlarınızı kontrol ediniz.", stoppingToken);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Müşteri {CustomerId} için parite işleme hatası", customerId);
                    errorCount++;
                }
            }
            
            // Sadece hata olduğunda logla
            if (errorCount > 0)
            {
                _logger.LogWarning(
                    "Parite yayınında hatalar oluştu. Başarılı: {SuccessCount}, Hata: {ErrorCount}", 
                    successfulSendCount, errorCount);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Parite yayını hazırlama sırasında hata oluştu");
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
            await _hubContext.Clients.All.SendAsync("SystemMessage", 
                new { Type = eventType, Message = message }, cancellationToken);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Sistem mesajı gönderme hatası");
        }
    }
    
    /// <summary>
    /// Sistem hata durumlarında loglama ve bildirim
    /// </summary>
    private async Task NotifySystemErrorAsync(string errorMessage)
    {
        try
        {
            _logger.LogCritical("SİSTEM HATASI: {ErrorMessage}", errorMessage);
            
            // Tüm bağlı müşterilere bilgi mesajı gönderilir
            await _hubContext.Clients.All.SendAsync("SystemMessage", 
                "Şu anda teknik bir sorun yaşanmaktadır. Kısa süre içinde düzelecektir.");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Sistem hatası bildirimi yapılırken ikincil hata oluştu");
        }
    }
} 