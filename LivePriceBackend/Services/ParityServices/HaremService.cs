using System.Globalization;
using LivePriceBackend.Entities;
using Newtonsoft.Json.Linq;

namespace LivePriceBackend.Services.ParityServices;

public static class HaremService
{
    private const string Endpoint = "https://canlipiyasalar.haremaltin.com/tmp/altin.json?dil_kodu=tr";

    public static async Task<List<ParityHamData>?> GetAll()
    {
        try
        {
            using var httpClient = new HttpClient();
            var response = await httpClient.GetStringAsync(Endpoint);
            var json = JObject.Parse(response);

            var data = json["data"];

            return data?.Select(item => new ParityHamData
                {
                    Symbol = item.First["code"]?.ToString() ?? string.Empty,
                    Ask = decimal.Parse(item.First["satis"]?.ToString() ?? "0"),
                    Bid = decimal.Parse(item.First["alis"]?.ToString() ?? "0"),
                    Date = DateTime.Parse(item.First["tarih"]?.ToString() ?? DateTime.MinValue.ToString(CultureInfo.InvariantCulture)),
                    Low = decimal.Parse(item.First["dusuk"]?.ToString() ?? "0"),
                    High = decimal.Parse(item.First["yuksek"]?.ToString() ?? "0"),
                    Close = decimal.Parse(item.First["kapanis"]?.ToString() ?? "0")
                })
                .ToList();
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            return null;
        }
    }
}