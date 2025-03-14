namespace LivePriceBackend.Services.Caching;

/// <summary>
/// Cache provider arayüzü - hem memory cache hem de distributed cache implementasyonları için temel
/// </summary>
public interface ICacheProvider
{
    /// <summary>
    /// Cache'den veri alır
    /// </summary>
    /// <typeparam name="T">Veri tipi</typeparam>
    /// <param name="key">Cache anahtarı</param>
    /// <returns>Cache'deki veri veya null</returns>
    Task<T?> GetAsync<T>(string key) where T : class;
    
    /// <summary>
    /// Cache'e veri ekler/günceller
    /// </summary>
    /// <typeparam name="T">Veri tipi</typeparam>
    /// <param name="key">Cache anahtarı</param>
    /// <param name="value">Eklenecek/güncellenecek değer</param>
    /// <param name="absoluteExpirationMinutes">Mutlak süre (dk) sonunda cache süresi dolar</param>
    /// <param name="slidingExpirationMinutes">Son erişimden itibaren (dk) sonunda süre dolar</param>
    Task SetAsync<T>(string key, T value, int? absoluteExpirationMinutes = null, int? slidingExpirationMinutes = null) where T : class;
    
    /// <summary>
    /// Cache'den veriyi siler
    /// </summary>
    /// <param name="key">Cache anahtarı</param>
    Task RemoveAsync(string key);
    
    /// <summary>
    /// Belirli bir desenle eşleşen tüm anahtarları siler
    /// </summary>
    /// <param name="pattern">Anahtar deseni (ör. "parity_*")</param>
    Task RemoveByPatternAsync(string pattern);
    
    /// <summary>
    /// Cache'deki tüm verileri temizler
    /// </summary>
    Task ClearAllAsync();
} 