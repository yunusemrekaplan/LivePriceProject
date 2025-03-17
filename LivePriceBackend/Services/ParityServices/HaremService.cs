using System.Globalization;
using System.Net;
using LivePriceBackend.DTOs;
using LivePriceBackend.DTOs.Service;
using LivePriceBackend.Entities;
using LivePriceBackend.Exceptions;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace LivePriceBackend.Services.ParityServices;

public class HaremServiceOptions
{
    public string BaseUrl { get; set; } = string.Empty;
    public string QueryParams { get; set; } = string.Empty;
    public int TimeoutSeconds { get; set; } = 10;
    public string DateFormat { get; set; } = "dd-MM-yyyy HH:mm:ss";
    public int RetryCount { get; set; } = 3;
    public int RetryIntervalSeconds { get; set; } = 1;
}

public interface IHaremService
{
    Task<List<ParityHamData>> GetAllAsync(CancellationToken cancellationToken = default);
}

public class HaremService : IHaremService
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILogger<HaremService> _logger;
    private readonly HaremServiceOptions _options;
    private readonly RateLimiter _rateLimiter;
    private const string SERVICE_NAME = "HaremService";

    // Önbellek değişkenleri
    private List<ParityHamData>? _cachedData;
    private DateTime _lastFetchTime = DateTime.MinValue;
    private readonly TimeSpan _cacheExpiration = TimeSpan.FromSeconds(2.9); // 3 saniyeye uygun önbellek süresi

    public HaremService(
        IHttpClientFactory httpClientFactory,
        ILogger<HaremService> logger,
        IOptions<HaremServiceOptions> options,
        RateLimiter rateLimiter)
    {
        _httpClientFactory = httpClientFactory;
        _logger = logger;
        _options = options.Value;
        _rateLimiter = rateLimiter;
    }

    public async Task<List<ParityHamData>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        // Önbellekte veri varsa ve süresi dolmadıysa doğrudan dön
        if (_cachedData != null && DateTime.UtcNow - _lastFetchTime < _cacheExpiration)
        {
            return _cachedData;
        }

        // Rate limiter üzerinden istek at
        return await _rateLimiter.ExecuteAsync(async () =>
        {
            try
            {
                var url = $"{_options.BaseUrl}?{_options.QueryParams}";
                
                var httpClient = _httpClientFactory.CreateClient("HaremClient");
                
                var response = await httpClient.GetAsync(url, cancellationToken);
                
                // HTTP hata kontrolü
                if (!response.IsSuccessStatusCode)
                {
                    var statusCode = response.StatusCode;
                    var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    
                    _logger.LogWarning("HaremService API hata döndürdü: {StatusCode}", statusCode);
                    
                    // Uygun hata tipini belirle
                    if (statusCode == HttpStatusCode.NotFound)
                    {
                        throw new ExternalServiceException(SERVICE_NAME, "API endpoint bulunamadı");
                    }
                    else if (statusCode == HttpStatusCode.Unauthorized || statusCode == HttpStatusCode.Forbidden)
                    {
                        throw new ExternalServiceException(SERVICE_NAME, "API erişim yetkisi hatası");
                    }
                    else if (statusCode >= HttpStatusCode.InternalServerError)
                    {
                        throw new ExternalServiceException(SERVICE_NAME, $"API sunucu hatası ({(int)statusCode})");
                    }
                    else
                    {
                        throw new ExternalServiceException(SERVICE_NAME, $"API isteği başarısız: {statusCode}");
                    }
                }
                
                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                
                JObject json;
                try
                {
                    json = JObject.Parse(content);
                }
                catch (JsonException ex)
                {
                    _logger.LogError(ex, "HaremService API yanıtı geçersiz JSON formatında");
                    throw new ExternalServiceException(SERVICE_NAME, "API yanıtı geçersiz JSON formatında", ex);
                }
                
                var data = json["data"];

                if (data == null)
                {
                    _logger.LogWarning("HaremService API'den veri alınamadı, 'data' alanı bulunamadı");
                    throw new ExternalServiceException(SERVICE_NAME, "API yanıtında 'data' alanı bulunamadı");
                }

                var result = new List<ParityHamData>();
                
                foreach (var item in data)
                {
                    try
                    {
                        var parityData = new ParityHamData
                        {
                            Symbol = item.First["code"]?.ToString() ?? string.Empty,
                            Ask = ParseDecimal(item.First["satis"]?.ToString() ?? "0"),
                            Bid = ParseDecimal(item.First["alis"]?.ToString() ?? "0"),
                            Date = DateTime.ParseExact(
                                item.First["tarih"]?.ToString() ?? DateTime.MinValue.ToString(_options.DateFormat),
                                _options.DateFormat,
                                CultureInfo.InvariantCulture,
                                DateTimeStyles.None),
                            Low = ParseDecimal(item.First["dusuk"]?.ToString() ?? "0"),
                            High = ParseDecimal(item.First["yuksek"]?.ToString() ?? "0"),
                            Close = ParseDecimal(item.First["kapanis"]?.ToString() ?? "0")
                        };
                        
                        result.Add(parityData);
                    }
                    catch (Exception)
                    {
                        // Tek bir pariteyi atlayıp devam et, loglama yapma
                    }
                }

                // Sonuçları önbelleğe al
                _cachedData = result;
                _lastFetchTime = DateTime.UtcNow;
                
                return result;
            }
            catch (ExternalServiceException)
            {
                // Zaten özel hatalarımızı fırlattık, tekrar sarmalayıp fırlatıyoruz
                throw;
            }
            catch (HttpRequestException ex)
            {
                _logger.LogError(ex, "HaremService API'ye erişim hatası");
                throw new ExternalServiceException(SERVICE_NAME, "API'ye erişim hatası: " + ex.Message, ex);
            }
            catch (TaskCanceledException ex)
            {
                _logger.LogError(ex, "HaremService API zaman aşımı");
                throw new ExternalServiceException(SERVICE_NAME, "API zaman aşımı", ex);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "HaremService API çağrısı sırasında beklenmeyen hata");
                throw new ExternalServiceException(SERVICE_NAME, "Beklenmeyen hata: " + ex.Message, ex);
            }
        }, cancellationToken);
    }
    
    private static decimal ParseDecimal(string value)
    {
        if (string.IsNullOrEmpty(value))
            return 0;
            
        // Replace comma with dot to handle "tr-TR" format
        value = value.Replace(',', '.');

        return decimal.TryParse(value, NumberStyles.AllowDecimalPoint | NumberStyles.AllowThousands, CultureInfo.InvariantCulture, out var result) ? result : 0;
    }
}