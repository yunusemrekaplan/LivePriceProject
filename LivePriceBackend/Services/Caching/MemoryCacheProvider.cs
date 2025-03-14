using Microsoft.Extensions.Caching.Memory;

namespace LivePriceBackend.Services.Caching;

public class MemoryCacheProvider : ICacheProvider
{
    private readonly IMemoryCache _memoryCache;
    private readonly ILogger<MemoryCacheProvider> _logger;
    private readonly object _lock = new();
    private readonly HashSet<string> _cacheKeys = new(); // Cache anahtarlarını izlemek için

    public MemoryCacheProvider(IMemoryCache memoryCache, ILogger<MemoryCacheProvider> logger)
    {
        _memoryCache = memoryCache;
        _logger = logger;
    }

    public Task<T?> GetAsync<T>(string key) where T : class
    {
        try
        {
            if (_memoryCache.TryGetValue(key, out T? value))
            {
                _logger.LogDebug("Cache hit için {Key}", key);
                return Task.FromResult(value);
            }

            _logger.LogDebug("Cache miss için {Key}", key);
            return Task.FromResult<T?>(null);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Cache'den veri alınırken hata oluştu: {Key}", key);
            return Task.FromResult<T?>(null);
        }
    }

    public Task SetAsync<T>(string key, T value, int? absoluteExpirationMinutes = null, int? slidingExpirationMinutes = null) where T : class
    {
        try
        {
            var options = new MemoryCacheEntryOptions();

            if (absoluteExpirationMinutes.HasValue)
            {
                options.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(absoluteExpirationMinutes.Value);
            }

            if (slidingExpirationMinutes.HasValue)
            {
                options.SlidingExpiration = TimeSpan.FromMinutes(slidingExpirationMinutes.Value);
            }

            // Eğer her iki süre de belirtilmediyse, varsayılan olarak 1 saat
            if (!absoluteExpirationMinutes.HasValue && !slidingExpirationMinutes.HasValue)
            {
                options.AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(1);
            }

            _memoryCache.Set(key, value, options);
            TrackKey(key);
            
            _logger.LogDebug("Cache set edildi: {Key}", key);
            return Task.CompletedTask;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Cache'e veri yazılırken hata oluştu: {Key}", key);
            return Task.CompletedTask;
        }
    }

    public Task RemoveAsync(string key)
    {
        try
        {
            _memoryCache.Remove(key);
            RemoveKeyFromTracker(key);
            
            _logger.LogDebug("Cache anahtarı silindi: {Key}", key);
            return Task.CompletedTask;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Cache anahtarı silinirken hata oluştu: {Key}", key);
            return Task.CompletedTask;
        }
    }

    public Task RemoveByPatternAsync(string pattern)
    {
        try
        {
            var matchingKeys = _cacheKeys
                .Where(key => key.Contains(pattern, StringComparison.OrdinalIgnoreCase))
                .ToList();

            foreach (var key in matchingKeys)
            {
                _memoryCache.Remove(key);
                RemoveKeyFromTracker(key);
            }

            _logger.LogDebug("{Count} adet cache anahtarı {Pattern} deseni ile silindi", matchingKeys.Count, pattern);
            return Task.CompletedTask;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Cache anahtarları desenle silinirken hata oluştu: {Pattern}", pattern);
            return Task.CompletedTask;
        }
    }

    public Task ClearAllAsync()
    {
        try
        {
            var keys = _cacheKeys.ToList();
            
            foreach (var key in keys)
            {
                _memoryCache.Remove(key);
            }
            
            lock (_lock)
            {
                _cacheKeys.Clear();
            }
            
            _logger.LogDebug("Tüm cache temizlendi, {Count} adet anahtar silindi", keys.Count);
            return Task.CompletedTask;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Tüm cache temizlenirken hata oluştu");
            return Task.CompletedTask;
        }
    }

    private void TrackKey(string key)
    {
        lock (_lock)
        {
            _cacheKeys.Add(key);
        }
    }

    private void RemoveKeyFromTracker(string key)
    {
        lock (_lock)
        {
            _cacheKeys.Remove(key);
        }
    }
} 