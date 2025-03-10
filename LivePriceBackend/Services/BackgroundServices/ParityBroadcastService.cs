using LivePriceBackend.Constants.Enums;
using LivePriceBackend.Data;
using LivePriceBackend.Entities;
using LivePriceBackend.Services.Hubs;
using LivePriceBackend.Services.ParityServices;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace LivePriceBackend.Services.BackgroundServices;

public class ParityBroadcastService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly IHubContext<ParityHub> _hubContext;
    private readonly ILogger<ParityBroadcastService> _logger;
    private readonly ConnectionTracker _connectionTracker;
    private readonly TimeSpan _interval = TimeSpan.FromSeconds(3); // 3 saniyede bir güncelleme

    public ParityBroadcastService(
        IServiceProvider serviceProvider,
        IHubContext<ParityHub> hubContext,
        ILogger<ParityBroadcastService> logger,
        ConnectionTracker connectionTracker)
    {
        _serviceProvider = serviceProvider;
        _hubContext = hubContext;
        _logger = logger;
        _connectionTracker = connectionTracker;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Parite Yayın Servisi başlatıldı");

        using var timer = new PeriodicTimer(_interval);

        while (!stoppingToken.IsCancellationRequested && await timer.WaitForNextTickAsync(stoppingToken))
        {
            try
            {
                await FetchAndBroadcastParitiesAsync(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Parite yayını sırasında hata oluştu");
            }
        }
    }

    private async Task FetchAndBroadcastParitiesAsync(CancellationToken stoppingToken)
    {
        try
        {
            // Aktif bağlantısı olan müşteri yoksa işlem yapma
            var connectedCustomerIds = _connectionTracker.GetConnectedCustomerIds().ToList();
            _logger.LogInformation("Bağlı müşteri sayısı: {Count}", connectedCustomerIds.Count);
            
            if (!connectedCustomerIds.Any())
            {
                _logger.LogInformation("Bağlı müşteri bulunamadı. İşlem yapılmayacak.");
                return;
            }

            // HaremService'den ham verileri çek
            var hamParities = await HaremService.GetAll() ?? new List<ParityHamData>();
            _logger.LogInformation("HaremService'den {Count} adet veri çekildi", hamParities.Count);
            
            if (!hamParities.Any())
            {
                _logger.LogWarning("HaremService'den veri alınamadı");
                return;
            }

            using var scope = _serviceProvider.CreateScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<LivePriceDbContext>();

            // DB'deki parite bilgilerini al
            var dbParities = await dbContext.Parities
                .AsNoTracking()
                .Include(p => p.ParityGroup)
                .Where(p => p.IsEnabled && p.ParityGroup.IsEnabled)
                .ToListAsync(stoppingToken);

            // Sadece bağlı müşteriler için kur ve grup kurallarını al
            var customerParityRules = await dbContext.CParityRules
                .AsNoTracking()
                .Where(r => connectedCustomerIds.Contains(r.CustomerId))
                .ToListAsync(stoppingToken);

            var customerGroupRules = await dbContext.CParityGroupRules
                .AsNoTracking()
                .Where(r => connectedCustomerIds.Contains(r.CustomerId))
                .ToListAsync(stoppingToken);

            // Her bağlı müşteri için pariteleri hazırla ve gönder
            foreach (var customerId in connectedCustomerIds)
            {
                if (!_connectionTracker.HasConnections(customerId))
                    continue;

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
                    {
                        _logger.LogWarning("Parite {Symbol} (RawSymbol: {RawSymbol}) için ham veri bulunamadı", 
                            dbParity.Symbol, dbParity.RawSymbol);
                        continue;
                    }

                    // Alış ve satış fiyatlarını müşteri kurallarına göre hesapla
                    var ask = hamData.Ask;
                    var bid = hamData.Bid;

                    // Spread kurallarını uygula
                    if (parityRule.SpreadRuleType.HasValue)
                    {
                        var askSpread = parityRule.SpreadForAsk ?? 0;
                        var bidSpread = parityRule.SpreadForBid ?? 0;

                        switch (parityRule.SpreadRuleType.Value)
                        {
                            case SpreadRuleType.Percentage:
                                ask = ask * (1 + askSpread / 100);
                                bid = bid * (1 - bidSpread / 100);
                                break;
                            case SpreadRuleType.Fixed:
                                ask = ask + askSpread;
                                bid = bid + bidSpread;
                                break;
                        }
                    }

                    // Değişim oranını hesapla
                    var change = hamData.Close > 0 ?
                        (decimal)Math.Round(((double)hamData.Bid - (double)hamData.Close) / (double)hamData.Close * 100, 2) :
                        0;

                    customerParities.Add(new
                    {
                        Symbol = dbParity.Symbol,
                        Ask = ask,
                        Bid = bid,
                        //Ask = Math.Round(ask, dbParity.Scale),
                        //Bid = Math.Round(bid, dbParity.Scale),
                        GroupName = dbParity.ParityGroup?.Name,
                        Change = change,
                        UpdateTime = DateTime.UtcNow
                    });
                }

                if (customerParities.Any())
                {
                    await _hubContext.Clients
                        .Group($"customer_{customerId}")
                        .SendAsync("ReceiveParities", customerParities, stoppingToken);
                    
                    _logger.LogInformation("Müşteri ID {CustomerId} için {Count} adet parite gönderildi", 
                        customerId, customerParities.Count);
                }
                else
                {
                    _logger.LogWarning("Müşteri ID {CustomerId} için gönderilecek parite bulunamadı", customerId);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Parite yayını hazırlama sırasında hata oluştu");
        }
    }
} 