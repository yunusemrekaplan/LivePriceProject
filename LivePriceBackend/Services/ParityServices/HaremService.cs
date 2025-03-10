using System.Globalization;
using LivePriceBackend.Entities;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace LivePriceBackend.Services.ParityServices;

public class HaremService
{
    private const string Endpoint = "https://canlipiyasalar.haremaltin.com/tmp/altin.json?dil_kodu=tr";
    private static readonly ILogger _logger;

    static HaremService()
    {
        var loggerFactory = LoggerFactory.Create(builder => 
            builder.AddConsole().AddDebug());
        _logger = loggerFactory.CreateLogger("HaremService");
    }

    public static async Task<List<ParityHamData>> GetAll()
    {
        try
        {
            _logger.LogInformation("HaremService API çağrısı yapılıyor: {Endpoint}", Endpoint);
            using var httpClient = new HttpClient();
            httpClient.Timeout = TimeSpan.FromSeconds(10);
            
            var response = await httpClient.GetStringAsync(Endpoint);
            _logger.LogInformation("HaremService API yanıt alındı, uzunluk: {Length}", response.Length);
            
            var json = JObject.Parse(response);
            var data = json["data"];

            if (data == null)
            {
                _logger.LogWarning("HaremService API'den veri alınamadı, 'data' null");
                return new List<ParityHamData>();
            }

            var result = data.Select(item => new ParityHamData
                {
                    Symbol = item.First["code"]?.ToString() ?? string.Empty,
                    Ask = decimal.Parse(item.First["alis"]?.ToString() ?? "0", CultureInfo.InvariantCulture),
                    Bid = decimal.Parse(item.First["satis"]?.ToString() ?? "0", CultureInfo.InvariantCulture),
                    Date = DateTime.ParseExact(
                        item.First["tarih"]?.ToString() ?? DateTime.MinValue.ToString("dd-MM-yyyy HH:mm:ss"),
                        "dd-MM-yyyy HH:mm:ss",
                        CultureInfo.InvariantCulture,
                        DateTimeStyles.None),
                    Low = decimal.Parse(item.First["dusuk"]?.ToString() ?? "0", CultureInfo.InvariantCulture),
                    High = decimal.Parse(item.First["yuksek"]?.ToString() ?? "0", CultureInfo.InvariantCulture),
                    Close = decimal.Parse(item.First["kapanis"]?.ToString() ?? "0", CultureInfo.InvariantCulture)
                })
                .ToList();

            _logger.LogInformation("HaremService API'den {Count} adet parite alındı", result.Count);
            return result;
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "HaremService API çağrısı sırasında HTTP hatası: {Message}", ex.Message);
            return new List<ParityHamData>();
        }
        catch (TaskCanceledException ex)
        {
            _logger.LogError(ex, "HaremService API çağrısı zaman aşımına uğradı");
            return new List<ParityHamData>();
        }
        catch (JsonException ex)
        {
            _logger.LogError(ex, "HaremService API yanıtı geçersiz JSON formatında");
            return new List<ParityHamData>();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "HaremService API çağrısı sırasında beklenmeyen hata");
            return new List<ParityHamData>();
        }
    }
}