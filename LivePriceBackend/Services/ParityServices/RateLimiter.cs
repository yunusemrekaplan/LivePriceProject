using System.Threading;
using System.Threading.RateLimiting;
using LivePriceBackend.Exceptions;

namespace LivePriceBackend.Services.ParityServices;

/// <summary>
/// Dış servislere yapılan istek sayısını sınırlamak için kullanılan servis
/// </summary>
public class RateLimiter
{
    private readonly TokenBucketRateLimiter _rateLimiter;
    private readonly ILogger<RateLimiter> _logger;

    public RateLimiter(ILogger<RateLimiter> logger)
    {
        // 3 saniyede 1 istek limiti ile bir TokenBucket rate limiter oluşturuyoruz
        _rateLimiter = new TokenBucketRateLimiter(new TokenBucketRateLimiterOptions
        {
            TokenLimit = 1,         // Maksimum 1 token (istek hakkı)
            QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
            QueueLimit = 1,         // Kuyrukta maksimum 1 istek bekleyebilir
            ReplenishmentPeriod = TimeSpan.FromSeconds(3), // 3 saniye periyot
            TokensPerPeriod = 1,    // Her periyotta 1 token eklenir
            AutoReplenishment = true // Otomatik token yenileme
        });
        
        _logger = logger;
    }

    /// <summary>
    /// Rate limit uygulayarak bir işlemi gerçekleştirir. 
    /// Limit aşıldığında işlemi sıraya alır veya reddeder.
    /// </summary>
    public async Task<T> ExecuteAsync<T>(Func<Task<T>> operation, CancellationToken cancellationToken = default)
    {
        using var lease = await _rateLimiter.AcquireAsync(1, cancellationToken);
        
        if (lease.IsAcquired)
        {
            try
            {
                return await operation();
            }
            catch (Exception)
            {
                // Hatayı yukarı bubblela
                throw;
            }
        }
        else
        {
            _logger.LogWarning("İstek hız limiti aşıldı, istek reddedildi");
            throw new ExternalServiceException("RateLimiter", "Dış servise istek gönderme hız limiti aşıldı. Lütfen daha sonra tekrar deneyin.");
        }
    }
} 