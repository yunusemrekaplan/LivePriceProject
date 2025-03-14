using LivePriceBackend.Data;
using LivePriceBackend.Entities;
using Microsoft.EntityFrameworkCore;

namespace LivePriceBackend.Services.Caching;

/// <summary>
/// Pariteler, parite kuralları ve grup kuralları için gelişmiş önbellek servisi
/// </summary>
public class ParityCache
{
    // Sabit cache keyleri
    private const string PARITIES_CACHE_KEY = "parities";
    private const string PARITY_RULES_CACHE_KEY = "parity_rules";
    private const string GROUP_RULES_CACHE_KEY = "group_rules";
    
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<ParityCache> _logger;
    private readonly ICacheProvider _cacheProvider;
    
    // Cache süresi configurasyonu - DI ile dışarıdan enjekte edilebilir
    private readonly TimeSpan _parityDataCacheTimeout = TimeSpan.FromMinutes(60); // 1 saat
    private readonly TimeSpan _customerRulesCacheTimeout = TimeSpan.FromMinutes(30); // 30 dakika
    
    public ParityCache(
        IServiceProvider serviceProvider, 
        ILogger<ParityCache> logger,
        ICacheProvider cacheProvider)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
        _cacheProvider = cacheProvider;
    }
    
    /// <summary>
    /// Tüm pariteleri getirir
    /// </summary>
    public async Task<List<Parity>> GetParitiesAsync()
    {
        var data = await _cacheProvider.GetAsync<List<Parity>>(PARITIES_CACHE_KEY);
        
        if (data == null)
        {
            _logger.LogInformation("Parite verisi önbellekte bulunamadı, veritabanından yükleniyor...");
            data = await LoadParitiesFromDatabaseAsync();
            
            // 1 saat cache'te tut
            await _cacheProvider.SetAsync(PARITIES_CACHE_KEY, data, 
                absoluteExpirationMinutes: (int)_parityDataCacheTimeout.TotalMinutes);
        }
        
        return data;
    }
    
    /// <summary>
    /// Belirli müşteriler için parite kurallarını getirir
    /// </summary>
    public async Task<List<CParityRule>> GetParityRulesAsync(IEnumerable<int> customerIds)
    {
        var allRules = await GetAllParityRulesAsync();
        return allRules.Where(r => customerIds.Contains(r.CustomerId)).ToList();
    }
    
    /// <summary>
    /// Belirli müşteriler için grup kurallarını getirir
    /// </summary>
    public async Task<List<CParityGroupRule>> GetGroupRulesAsync(IEnumerable<int> customerIds)
    {
        var allRules = await GetAllGroupRulesAsync();
        return allRules.Where(r => customerIds.Contains(r.CustomerId)).ToList();
    }
    
    /// <summary>
    /// Tüm parite kurallarını getirir
    /// </summary>
    private async Task<List<CParityRule>> GetAllParityRulesAsync()
    {
        var data = await _cacheProvider.GetAsync<List<CParityRule>>(PARITY_RULES_CACHE_KEY);
        
        if (data == null)
        {
            _logger.LogInformation("Parite kuralları önbellekte bulunamadı, veritabanından yükleniyor...");
            data = await LoadParityRulesFromDatabaseAsync();
            
            // 30 dk cache'te tut
            await _cacheProvider.SetAsync(PARITY_RULES_CACHE_KEY, data, 
                absoluteExpirationMinutes: (int)_customerRulesCacheTimeout.TotalMinutes);
        }
        
        return data;
    }
    
    /// <summary>
    /// Tüm grup kurallarını getirir
    /// </summary>
    private async Task<List<CParityGroupRule>> GetAllGroupRulesAsync()
    {
        var data = await _cacheProvider.GetAsync<List<CParityGroupRule>>(GROUP_RULES_CACHE_KEY);
        
        if (data == null)
        {
            _logger.LogInformation("Grup kuralları önbellekte bulunamadı, veritabanından yükleniyor...");
            data = await LoadGroupRulesFromDatabaseAsync();
            
            // 30 dk cache'te tut
            await _cacheProvider.SetAsync(GROUP_RULES_CACHE_KEY, data, 
                absoluteExpirationMinutes: (int)_customerRulesCacheTimeout.TotalMinutes);
        }
        
        return data;
    }
    
    /// <summary>
    /// Tüm cache'i temizler - manuel olarak yapılabilir
    /// </summary>
    public async Task ForceRefreshAsync()
    {
        await _cacheProvider.ClearAllAsync();
        _logger.LogInformation("Parite önbelleği manuel olarak temizlendi");
    }
    
    /// <summary>
    /// Parite verilerini yeniler
    /// </summary>
    public async Task RefreshParitiesAsync()
    {
        await _cacheProvider.RemoveAsync(PARITIES_CACHE_KEY);
        _logger.LogInformation("Parite önbelleği temizlendi");
    }
    
    /// <summary>
    /// Parite kurallarını yeniler
    /// </summary>
    public async Task RefreshParityRulesAsync()
    {
        await _cacheProvider.RemoveAsync(PARITY_RULES_CACHE_KEY);
        _logger.LogInformation("Parite kuralları önbelleği temizlendi");
    }
    
    /// <summary>
    /// Grup kurallarını yeniler
    /// </summary>
    public async Task RefreshGroupRulesAsync()
    {
        await _cacheProvider.RemoveAsync(GROUP_RULES_CACHE_KEY);
        _logger.LogInformation("Grup kuralları önbelleği temizlendi");
    }
    
    /// <summary>
    /// Belirli bir müşterinin kurallarını yeniler
    /// </summary>
    public async Task RefreshCustomerRulesAsync(int customerId)
    {
        // Tüm kuralları yenile - optimizasyon alanı: sadece ilgili müşteri için
        await RefreshParityRulesAsync();
        await RefreshGroupRulesAsync();
        _logger.LogInformation("Müşteri {CustomerId} kuralları önbelleği temizlendi", customerId);
    }
    
    /// <summary>
    /// Pariteleri veritabanından yükler
    /// </summary>
    private async Task<List<Parity>> LoadParitiesFromDatabaseAsync()
    {
        try
        {
            using var scope = _serviceProvider.CreateScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<LivePriceDbContext>();
            
            return await dbContext.Parities
                .AsNoTracking()
                .Include(p => p.ParityGroup)
                .Where(p => p.IsEnabled && p.ParityGroup.IsEnabled)
                .ToListAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Pariteler veritabanından yüklenirken hata oluştu");
            return new List<Parity>();
        }
    }
    
    /// <summary>
    /// Parite kurallarını veritabanından yükler
    /// </summary>
    private async Task<List<CParityRule>> LoadParityRulesFromDatabaseAsync()
    {
        try
        {
            using var scope = _serviceProvider.CreateScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<LivePriceDbContext>();
            
            return await dbContext.CParityRules
                .AsNoTracking()
                .ToListAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Parite kuralları veritabanından yüklenirken hata oluştu");
            return new List<CParityRule>();
        }
    }
    
    /// <summary>
    /// Grup kurallarını veritabanından yükler
    /// </summary>
    private async Task<List<CParityGroupRule>> LoadGroupRulesFromDatabaseAsync()
    {
        try
        {
            using var scope = _serviceProvider.CreateScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<LivePriceDbContext>();
            
            return await dbContext.CParityGroupRules
                .AsNoTracking()
                .ToListAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Grup kuralları veritabanından yüklenirken hata oluştu");
            return new List<CParityGroupRule>();
        }
    }
} 