using System.Xml;
using System.Globalization;
using LivePriceBackend.Entities;
using LivePriceBackend.Exceptions;
using Microsoft.Extensions.Options;

namespace LivePriceBackend.Services.ParityServices;

public class XmlParityServiceOptions
{
    public string BaseUrl { get; set; } = string.Empty;
    public int TimeoutSeconds { get; set; } = 10;
    public string DateFormat { get; set; } = "dd.MM.yyyy HH:mm:ss";
    public int RetryCount { get; set; } = 3;
    public int RetryIntervalSeconds { get; set; } = 1;
}

public interface IXmlParityService
{
    Task<List<ParityHamData>> GetAllAsync(CancellationToken cancellationToken = default);
    Task<List<ParityHamData>> GetBySymbolsAsync(string[] symbols, CancellationToken cancellationToken = default);
}

public class XmlParityService(
    IHttpClientFactory httpClientFactory,
    ILogger<XmlParityService> logger,
    IOptions<XmlParityServiceOptions> options,
    RateLimiter rateLimiter)
    : IXmlParityService
{
    private readonly XmlParityServiceOptions _options = options.Value;
    private const string ServiceName = "XmlParityService";

    // Önbellek değişkenleri
    private List<ParityHamData>? _cachedData;
    private DateTime _lastFetchTime = DateTime.MinValue;
    private readonly TimeSpan _cacheExpiration = TimeSpan.FromSeconds(2.9); // 3 saniyeye uygun önbellek süresi

    public async Task<List<ParityHamData>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        // Önbellekte veri varsa ve süresi dolmadıysa doğrudan dön
        if (_cachedData != null && DateTime.UtcNow - _lastFetchTime < _cacheExpiration)
        {
            return _cachedData;
        }

        // Rate limiter üzerinden istek at
        return await rateLimiter.ExecuteAsync(async () =>
        {
            try
            {
                var url = _options.BaseUrl;
                var httpClient = httpClientFactory.CreateClient("XmlParityClient");

                var response = await httpClient.GetAsync(url, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var statusCode = response.StatusCode;
                    var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);

                    logger.LogWarning("XmlParityService API hata döndürdü: {StatusCode}", statusCode);
                }

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                var document = new XmlDocument();
                document.LoadXml(content);

                var result = ParseXmlData(document);

                // Sonuçları önbelleğe al
                _cachedData = result;
                _lastFetchTime = DateTime.UtcNow;

                return result;
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "XmlParityService API çağrısı sırasında beklenmeyen hata");
                throw new ExternalServiceException(ServiceName, "Beklenmeyen hata: " + ex.Message, ex);
            }
        }, cancellationToken);
    }

    public async Task<List<ParityHamData>> GetBySymbolsAsync(string[] symbols, CancellationToken cancellationToken = default)
    {
        if (symbols == null || symbols.Length == 0)
        {
            throw new ArgumentException("En az bir sembol belirtilmelidir", nameof(symbols));
        }

        var url = $"{_options.BaseUrl}&sembol=({string.Join(',', symbols)})";
        var httpClient = httpClientFactory.CreateClient("XmlParityClient");

        var response = await httpClient.GetAsync(url, cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            throw new ExternalServiceException(ServiceName, $"API isteği başarısız: {response.StatusCode}");
        }

        var content = await response.Content.ReadAsStringAsync(cancellationToken);
        var document = new XmlDocument();
        document.LoadXml(content);

        return ParseXmlData(document);
    }

    private List<ParityHamData> ParseXmlData(XmlDocument document)
    {
        var result = new List<ParityHamData>();
        var nodeList = document.SelectNodes("/dataveri/data");

        if (nodeList == null || nodeList.Count == 0)
        {
            logger.LogWarning("XmlParityService API'den veri alınamadı, 'data' alanı bulunamadı");
            return result;
        }

        foreach (XmlNode node in nodeList)
        {
            try
            {
                var tarihStr = node["tarih"]?.InnerText;
                if (string.IsNullOrEmpty(tarihStr))
                {
                    logger.LogWarning("Tarih alanı boş veya null: {Symbol}", node["sembol"]?.InnerText);
                    continue;
                }

                if (!DateTime.TryParseExact(
                        tarihStr,
                        _options.DateFormat,
                        CultureInfo.InvariantCulture,
                        DateTimeStyles.None,
                        out var date))
                {
                    logger.LogWarning("Geçersiz tarih formatı: {TarihStr}, Sembol: {Symbol}",
                        tarihStr, node["sembol"]?.InnerText);
                    continue;
                }

                var parityData = new ParityHamData
                {
                    Symbol = node["sembol"]?.InnerText ?? string.Empty,
                    Ask = decimal.TryParse(node["alis"]?.InnerText, out var ask) ? ask : 0,
                    Bid = decimal.TryParse(node["satis"]?.InnerText, out var bid) ? bid : 0,
                    Date = date,
                    Low = decimal.TryParse(node["dusuk"]?.InnerText, out var low) ? low : 0,
                    High = decimal.TryParse(node["yuksek"]?.InnerText, out var high) ? high : 0,
                    Close = decimal.TryParse(node["son"]?.InnerText, out var close) ? close : 0,
                    DailyChange = decimal.TryParse(node["gunlukyuzde"]?.InnerText, out var dailyChange) ? dailyChange : 0
                };

                if (string.IsNullOrEmpty(parityData.Symbol))
                {
                    logger.LogWarning("Sembol alanı boş veya null");
                    continue;
                }

                result.Add(parityData);
            }
            catch (Exception ex)
            {
                logger.LogWarning(ex, "XML verisi ayrıştırılırken hata oluştu: {Symbol}",
                    node["sembol"]?.InnerText ?? "Bilinmeyen Sembol");
            }
        }

        return result;
    }
}