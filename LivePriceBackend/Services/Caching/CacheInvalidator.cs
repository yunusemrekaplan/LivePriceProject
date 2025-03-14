namespace LivePriceBackend.Services.Caching;

/// <summary>
/// Cache invalidation için event tanımları
/// </summary>
public class CacheInvalidationEvent
{
    /// <summary>
    /// Müşteri ID - Boş ise tüm müşteri cache'i temizlenir
    /// </summary>
    public int? CustomerId { get; set; }
    
    /// <summary>
    /// Parite ID - Boş ise tüm parite cache'i temizlenir
    /// </summary>
    public int? ParityId { get; set; }
    
    /// <summary>
    /// ParityGroup ID - Boş ise tüm parite grubu cache'i temizlenir
    /// </summary>
    public int? ParityGroupId { get; set; }
    
    /// <summary>
    /// Genel cache temizleme
    /// </summary>
    public bool ClearAll { get; set; }
}

/// <summary>
/// Cache invalidation için olay yöneticisi
/// </summary>
public class CacheInvalidator
{
    private readonly ParityCache _parityCache;
    private readonly ILogger<CacheInvalidator> _logger;
    
    public CacheInvalidator(ParityCache parityCache, ILogger<CacheInvalidator> logger)
    {
        _parityCache = parityCache;
        _logger = logger;
    }
    
    /// <summary>
    /// Cache invalidation olayı gönderir
    /// </summary>
    public async Task InvalidateCacheAsync(CacheInvalidationEvent @event)
    {
        try
        {
            _logger.LogInformation("Cache invalidation olayı alındı: CustomerId={CustomerId}, ParityId={ParityId}, ParityGroupId={ParityGroupId}, ClearAll={ClearAll}",
                @event.CustomerId, @event.ParityId, @event.ParityGroupId, @event.ClearAll);
            
            if (@event.ClearAll)
            {
                await _parityCache.ForceRefreshAsync();
                return;
            }
            
            if (@event.CustomerId.HasValue)
            {
                await _parityCache.RefreshCustomerRulesAsync(@event.CustomerId.Value);
            }
            
            if (@event.ParityId.HasValue || @event.ParityGroupId.HasValue)
            {
                await _parityCache.RefreshParitiesAsync();
            }
            
            // Hiçbir spesifik ID belirtilmediyse, ilgili tüm cache'i temizle
            if (!@event.CustomerId.HasValue && !@event.ParityId.HasValue && !@event.ParityGroupId.HasValue && !@event.ClearAll)
            {
                await _parityCache.RefreshParitiesAsync();
                await _parityCache.RefreshParityRulesAsync();
                await _parityCache.RefreshGroupRulesAsync();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Cache invalidation sırasında hata oluştu");
        }
    }
    
    /// <summary>
    /// Müşteri değişikliği için cache'i temizler
    /// </summary>
    public async Task InvalidateCustomerCacheAsync(int customerId)
    {
        await InvalidateCacheAsync(new CacheInvalidationEvent { CustomerId = customerId });
    }
    
    /// <summary>
    /// Parite değişikliği için cache'i temizler
    /// </summary>
    public async Task InvalidateParityCacheAsync(int parityId)
    {
        await InvalidateCacheAsync(new CacheInvalidationEvent { ParityId = parityId });
    }
    
    /// <summary>
    /// Parite grubu değişikliği için cache'i temizler
    /// </summary>
    public async Task InvalidateParityGroupCacheAsync(int parityGroupId)
    {
        await InvalidateCacheAsync(new CacheInvalidationEvent { ParityGroupId = parityGroupId });
    }
    
    /// <summary>
    /// Tüm cache'i temizler
    /// </summary>
    public async Task InvalidateAllCacheAsync()
    {
        await InvalidateCacheAsync(new CacheInvalidationEvent { ClearAll = true });
    }
} 